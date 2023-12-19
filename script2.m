%% MAIN
load data.mat
interface();

%% INTERFACE
function interface()
    while(1)
        option = input(['1 - Display available genres' ...
                        '\n2 - Number of movies of a genre' ...
                        '\n3 - Number of movies of a genre on a given year' ...
                        '\n4 - Search movie titles' ...
                        '\n5 - Search movies based on genres' ...
                        '\n6 - Exit' ...
                        '\nSelect an option: ']);
    
        switch option
            case 1

            case 2
                genre = input("Select a genre:","s");
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