clear all;
clc;

movies = readcell('movies.csv', 'Delimiter', ',');

genres = getGenres(movies); % teste values genres
titles = getTitles(movies); % teste values titles
year = getYear(movies)

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
