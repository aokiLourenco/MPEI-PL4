%% MAIN
load data.mat
%interface(genres,BF,BF_years,years,matrixMinHashTitles,numHash,titles,shingleSize);
%searchTitle(matrixMinHashTitles, numHash, titles, shingleSize)
%filterSimilar(titles,matrixMinHashTitles,minHash_search,numHash)

%% INTERFACE
%function interface(genres,BF,BF_years,years,matrixMinHashTitles,numHash,titles,shingleSize)
while(1)
    option = input(['\n1 - Display available genres' ...
                    '\n2 - Number of movies of a genre' ...
                    '\n3 - Number of movies of a genre on a given year' ...
                    '\n4 - Search movie titles' ...
                    '\n5 - Search movies based on genres' ...
                    '\n6 - Exit' ...
                    '\nSelect an option: ']);

    switch option
        case 1
            fprintf("Available genres:\n")
            for i = 2:length(genres)
                fprintf("-%s \n", genres{i});
            end

        case 2
            genre = input("Select a genre: ","s");
            a=0;
            for x = 1:length(genres)
                if strcmp(genre, genres{x})
                    a=1;
                    break;
                end
            end
            if a==1
                check=min(valid(genre,BF,6));
                fprintf("\nMovies of '%s' genre: %d\n",genre,check)
            else
                fprintf("\nGenre doesn't exist. Press 1 to see available genres.\n")
            end
            
        case 3
            genre_year = input("Select a genre and a year (separated by ','): ","s");
            values = strsplit(genre_year, ',');
            a=0;
            b=0;
            for x = 1:length(genres)
                if strcmp(values{1}, genres{x})
                    a=1;
                    break;
                end
            end
            for x = 1:length(years)
                if str2num(values{2}) == years(x)
                    b=1;
                    break;
                end
            end

            if a==1 && b==1

                check=min(valid2(values{1},values{2},BF_years,6));
                fprintf("\nMovies of genre %s on year %d: %d\n",values{1},str2num(values{2}),check)

            else
                fprintf("Invalid Inputs\n")
            end

        case 4
            search = lower(input("Insert a string: ","s"));
            fprintf('\n');

            while (length(search) < shingleSize)
                fprintf("String must have at least %d characters\n", shingleSize);
                search = lower(input("Insert a string: ","s"));
            end

            searchTitle(search, matrizMinHashTitles, numHash, titles, shingleSize, genres)

        case 5
            selectedGenres = input("Select one or more genres (separated by ','): ","s");
            values = strsplit(selectedGenres, ',');

            isValid = all(arrayfun(@(genre) checkBloomFilter(genre, genreBloomFilter), values));

            if isValid
                [sortedMovies, sortedIndices] = calculateAndSortSimilarity(values, movies, genreSignatureMatrix);
                
                for i = 1:min(5, length(sortedMovies))
                    fprintf('%s - Year: %d - Similarity: %f', sortedMovies{i}, movies{sortedIndices(i), 2}, sortedMovies{i}.similarity);
                end
            else
                disp('One or more genres entered are not valid.');
            end            

        case 6
            return
            
        otherwise
                fprintf("Invalid Option\n");
    end
end


%==========================Auxiliar Funcs==========================
function check = valid(elemento, BF, k)
    n = length(BF);
    for i = 1:k
        elemento = [elemento num2str(i)];
        h = DJB31MA(elemento, 127);
        h = mod(h,n) + 1; %para dar valor entre 1 e n para por no BF
        if BF(h)
            check(i) = BF(h);
        else
            check(i) = 0;
        end
    end
end

function check = valid2(elemento, ano, BF, k)
    n = length(BF);
    for i = 1:k
        elemento = [num2str(ano) elemento num2str(i)];
        h = DJB31MA(elemento, 127);
        h = mod(h,n) + 1; %para dar valor entre 1 e n para por no BF
        if BF(h)
            check(i) = BF(h);
        else
            check(i) = 0;
        end
    end
end

function searchTitle(search, matrizMinHashTitles, numHash, titles, shingleSize, genres)
    minHashSearch = inf(1, numHash);
    for j = 1 : (length(search) - shingleSize + 1)
        shingle = char(search(j:(j+shingleSize-1))); 
        h = zeros(1, numHash);
        for i = 1 : numHash
            shingle = [shingle num2str(i)];
            h(i) = DJB31MA(shingle, 127);
        end
        minHashSearch(1, :) = min([minHashSearch(1, :); h]);
    end
   
    threshold = 0.99;
    [similarTitles,distancesTitles,k] = filterSimilar(threshold,titles,matrizMinHashTitles,minHashSearch,numHash);
         
    if (k == 0)
        disp('No results found');
    elseif (k > 5)
        k = 5;
    end
    
    distances = cell2mat(distancesTitles);
    [distances, index] = sort(distances);
    
    for h = 1 : k
        fprintf('%s - Similarity: %.3f\n%s', similarTitles{index(h)}, distances(h));
        fprintf("\n==========================\n\n")
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

function [similarTitles,distancesTitles,k] = filterSimilar(threshold,titles,matrizMinHashTitles,minHash_search,numHash)
    similarTitles = {};
    distancesTitles = {};
    numTitles = length(titles);
    k=0;
    for n = 1 : numTitles
        distancia = 1 - (sum(minHash_search(1, :) == matrizMinHashTitles(n,:)) / numHash);
        if (distancia < threshold)
            k = k+1;
            similarTitles{k} = titles{n};
            distancesTitles{k} = distancia;
        end
    end
end

% For each movie, should show the Jaccard similarity between the selected genres and the movie genres
function [similarGenres, distancesGenres, k] = similar(selectedGenresMinHash, matrizMinHashGenres, genres)
    similarGenres = {};
    distancesGenres = {};
    numGenres = length(genres);
    k = 0;
    for n = 1 : numGenres
        distancia = 1 - (sum(selectedGenresMinHash(1, :) == matrizMinHashGenres(n,:)) / numHash);
        if (distancia < threshold)
            k = k+1;
            similarGenres{k} = genres{n};
            distancesGenres{k} = distancia;
        end
    end
end
