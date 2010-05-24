import java.util.Vector;

public class Draw
  {
    public static void main(String[] args)
    {
      int numPlayers = 9;
      int numWeeks =10;
      int numMatchesPerWeekPerPlayer = 2;
      int maxMatchesPerWeek = 6;
      Vector[] weekMatches = new Vector[numWeeks];
      for(int i=0;i<numWeeks;i++)
        weekMatches[i]=new Vector();
        for(int i=0;i<numPlayers-1;i++)
          {
            for(int j=i+1;j<numPlayers;j++)
              {
                boolean matchPlayed = false;
                String player1 = new Integer(i).toString();
                String player2 = new Integer(j).toString();

                for(int k=0;k<numWeeks;k++)
                  {
                    if(weekMatches[k].size()/2 == maxMatchesPerWeek)
                      continue;
                      int matches = matchesPlayedBy(weekMatches[k],player1);
                      if(matches == numMatchesPerWeekPerPlayer)
                        continue;
                        matches = matchesPlayedBy(weekMatches[k],player2);
                        if(matches == numMatchesPerWeekPerPlayer)
                          continue;
                          weekMatches[k].add(player1);
                          weekMatches[k].add(player2);
                          matchPlayed = true;
                          break;
                        }
                        c
                        {
                          System.out.println("Warning:: Cannot Accomodate Match:"+player1+" vs "+player2);
                        }
                      }
                    }
                    for(int i=0;i<numWeeks;i++)
                      {
                        System.out.println("\n\nWeek:"+i);
                        int k=0;
                        for(int j=0;j<weekMatches[i].size();j++)
                          {
                            if(j%2 == 0)
                              System.out.println();
                            else
                              if(j!=0)
                                System.out.print(" vs ");

                                System.out.print(weekMatches[i].elementAt(k++));

                              }
                            }
                          }

                          static int matchesPlayedBy(Vector v, String player)
                          {
                            int ret=0;
                            for(int i=0;i<v.size();i++)
                              {
                                if (v.elementAt(i).toString().equals(player))
                                  ret++;
                                }
                                return ret;
                              }
                            }



                      

