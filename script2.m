%% MAIN
load data.mat
interface(genres,BF);

%% INTERFACE
function interface(genres,BF)
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
                    fprintf("%s, ", genres{i});
                end

            case 2
                genre = input("Select a genre:","s");
                check=min(valid(genre,BF,3));
                fprintf("Movies of '%s' genre: %d\n",genre,check)

            case 3
                genre_year = input("Select a genre and a year (separated by ','):","s");
                values = strsplit(genre_year, ',');
                %fprintf ("%s , %d\n", values{1}, str2num(values{2}));
            case 4
                name = input("Insert a string:","s");
            case 5
                genres = input("Select one or more genres (separated by ','):","s");
                values = strsplit(genres, ',');
            case 6
                return
            otherwise
                 fprintf("Invalid Option\n");
        end
    end
end






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


    
function h= DJB31MA( chave, seed)
    len= length(chave);
    chave= double(chave);
    h= seed;
    for i=1:len
        h = mod(31 * h + chave(i), 2^32 -1) ;
    end
end