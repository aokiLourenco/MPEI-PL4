clear;
clc;
k=3;
movies = readcell('movies.csv', 'Delimiter', ',');

genres = getGenres(movies); % teste values genres
titles = getTitles(movies); % teste values titles
years = getYear(movies); % teste values years

BF = init(length(genres)*8);

for i = 1:height(movies)
    for j=3:12
        BF = insert(movies{i, j}, BF, k);
    end
end

save data.mat genres BF


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

function titles = getTitles(movies)
    titles = {};
    k = 1;

    for i = 1:height(movies)
        titles{k} = movies{i, 1};
        k = k + 1;
    end
end

function year = getYear(movies)
    year = {};
    k = 1;

    for i = 1:height(movies)
        year{k} = movies{i, 2};
        k = k + 1;
    end
end

%BF funtions
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

    
function h= DJB31MA( chave, seed)
    len= length(chave);
    chave= double(chave);
    h= seed;
    for i=1:len
        h = mod(31 * h + chave(i), 2^32 -1) ;
    end
end