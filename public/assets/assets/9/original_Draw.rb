class Draw

  #def initialize
    i = 0
    j = 0
    k = 0
    numPlayers = 9;
    numWeeks =10;
    numMatchesPerWeekPerPlayer = 2;
    maxMatchesPerWeek = 6;
  #end
  weekMatches = Array.new(numWeeks)
puts "ssssssssssssssssss",weekMatches
  for i in 0..numWeeks
    weekMatches[i]= Array.new();
    for i in 0..numPlayers-1
      j=i+1
      for j in j..numPlayers
        matchPlayed = false;
        player1 = i.to_s;
        player2 = j.to_s;
        for k in k..numWeeks
          if(weekMatches[k].size()/2 == maxMatchesPerWeek)
            continue;
            matches = matchesPlayedBy(weekMatches[k],player1);
            if(matches == numMatchesPerWeekPerPlayer)
              continue;
              matches = matchesPlayedBy(weekMatches[k],player2);
              if(matches == numMatchesPerWeekPerPlayer)
                continue;
                weekMatches[k].add(player1);
                weekMatches[k].add(player2);
                matchPlayed = true;
                break;
              end
            end
          end
          k = k+1
        end
      end
    end
  end
end
