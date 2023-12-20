clear;
clc;
k=6;
movies = readcell('movies.csv', 'Delimiter', ',');
movies = movies(1:1000, :);

%==========================Option 1==========================
genres = getGenres(movies);
%============================================================

%==========================Option 2==========================
BF = init(length(genres)*8);

BF_years = init(length(genres)*length(years)*8);

for i = 1:height(movies)
    for j=3:12
        BF = insert(movies{i, j}, BF, k);
        BF_years = insert2(movies{i,j},BF_years,k,movies{i,2});
    end
end
%==============================================================

%==========================Option 3============================

%==============================================================

%==========================Option 4============================
titles = movies(:, 1);
numTitles = length(titles);
numHash = 100;
shingleSize = 3;
matrixMinHashTitles = minHashTitles(titles, numHash, shingleSize);
distanceTitles = getDistancesMinHashTitles(numTitles, matrixMinHashTitles, numHash);
%==============================================================

%==========================Save in data========================
save data.mat genres BF BF_years years
%==============================================================


%==========================Get Things==========================

function genres = getGenres(movies)
    genres = {};
    k = 1;

    for i = 1:height(movies)
        for j = 3:12
            if ~anymissing(movies{i, j}) && ~strcmp(movies{i, j}, 'unkown')
                genres{k} = movies{i, j};
                k = k + 1;
            end
        end
    end

    genres = unique(genres);
end

function year = getYear(movies)
    k = 1;

    for i = 1:height(movies)
        year2(k) = movies{i, 2};
        k = k + 1;
    end
    year = unique (year2) ;
end
%================================================================


%==========================Bloom Filter==========================
function BF = init(n)
    BF = zeros(1,n);
end


function BF = insert(elemento, BF, k)
    n = length(BF);
        for i = 1:k
            if ~ismissing(elemento)
                elemento = [elemento num2str(i)];
                h = DJB31MA(elemento, 127);
                h = mod(h,n) + 1; %para dar valor entre 1 e n para por no BF
                BF(h) = BF(h)+1;
            end
        end
end

function BF = insert2(elemento, BF, k, ano)
    n = length(BF);
        for i = 1:k
            if ~ismissing(elemento)
                elemento = [num2str(ano) elemento num2str(i)];
                h = DJB31MA(elemento, 127);
                h = mod(h,n) + 1; %para dar valor entre 1 e n para por no BF
                BF(h) = BF(h)+1;
            end
        end
end

    
function h= DJB31MA( chave, seed)
    len= length(chave);
    chave= double(chave);
    h= seed;
    for i=1:len
        h = mod(31 * h + chave(i), 2^32 -1) ;
    end
end

%==========================MinHash==========================

function matrixMinHashTitles = minHashTitles(titles, numHash, shingleSize)
    numTitles = length(titles);
    matrixMinHashTitles = inf(numTitles, numHash);
    
    x = waitbar(0, 'MinHash Titles');
    for k = 1:numTitles
        waitbar(k/numTitles, x);
        movie = titles{k};
        for j = 1:(length(movie) - shingleSize + 1)
            shingle = lower(char(movie(j:(j + shingleSize - 1))));
            h = zeros(1, numHash);
            for i = 1:numHash
                shingle = [shingle num2str(i)];
                h(i) = DJB31MA(shingle, 127);
            end
        matrixMinHashTitles(k, :) = min([matrixMinHashTitles(k, :), h]);
        end
    end
    delete(x);
end

function distances = getDistancesMinHashTitles(numTitles, matrixMinHash, numHash)
    distances = zeros(numTitles,numTitles);
    for n1= 1:numTitles
        for n2= n1+1:numTitles
            distances(n1,n2) = sum(matrixMinHash(n1,:)==matrixMinHash(n2,:))/numHash;
        end
    end
end