clear;
clc;

movies = readcell('movies.csv', 'Delimiter', ',');
k=6;

%==========================Option 1===========================
genres = getGenres(movies);
years = getYear(movies);
%=============================================================


%==========================Option 2 & 3=======================
BF = init(length(genres)*8);

BF_years = init(length(genres)*length(years)*8);

for i = 1:height(movies)
    for j=3:12
        BF = insert(movies{i, j}, BF, k);
        BF_years = insert2(movies{i,j},BF_years,k,movies{i,2});
    end
end
%==============================================================


%==========================Option 4============================
titles = movies(:,1);
numTitles = length(titles);
numHash = 100;
shingleSize = 3; 
matrizMinHashTitles = minHashTitles(titles,numHash,shingleSize);
%==============================================================


%==========================Option 5============================
numFilms = height(movies);
numGenres = length(genres);
matrizMinHashGenres = minHash(movies(:,3:12),numHash);
%==============================================================


%==========================Save in data========================
save data.mat genres BF BF_years years matrizMinHashTitles matrizMinHashGenres numHash shingleSize titles numFilms numGenres numTitles movies
%==============================================================


%==========================Get Things==========================
function genres = getGenres(movies)
    genres = {};
    k = 1;

    for i = 1:height(movies)
        for j = 3:7
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
%================================================================


%========================MinHash Titles==========================
function matrizMinHashTitles = minHashTitles(titles,numHash,shingleSize)
    numTitles = length(titles);
    matrizMinHashTitles = inf(numTitles, numHash);
    
    x = waitbar(0,'MinHash Titles');
    for k= 1 : numTitles
        waitbar(k/numTitles,x);
        movie = titles{k};
        for j = 1 : (length(movie) - shingleSize + 1)
            shingle = lower(char(movie(j:(j+shingleSize-1)))); 
            h = zeros(1, numHash);
            for i = 1 : numHash
                shingle = [shingle num2str(i)];
                h(i) = DJB31MA(shingle, 127);
            end
        matrizMinHashTitles(k, :) = min([matrizMinHashTitles(k, :); h]);
        end
    end
    delete(x);
end


%========================MinHash Genres==========================

function matrizMinHashGenres = minHash(genres,numHash)
    numGenres = height(genres);
    matrizMinHashGenres = inf(numGenres, numHash);
    x = waitbar(0,'MinHash Genre');
    for k = 1:numGenres
        waitbar(k/numGenres,x);
        shingle="";
        values = genres(k,:);
        for j = 1 : (height(values))
            shingle = [shingle values{j,1}];
            h = zeros(1, numHash);
            for i = 1 : numHash
                shingle = [shingle num2str(i)];
                h(i) = DJB31MA(shingle, 127);
            end
            matrizMinHashGenres(1, :) = min([matrizMinHashGenres(1, :); h]);
        end
     end
    delete(x);

end

%================================================================
