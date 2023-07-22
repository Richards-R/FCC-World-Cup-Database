#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL"TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != year ]]
then

    #get winner team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
   
    #if wiiner not found in teams
    if [[ -z $TEAM_ID ]]
    then
      #insert winner team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, winner team named $WINNER
      fi
      #get new team_id
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
fi

if [[ $YEAR != year ]]
then

    #get opponent team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
   
    #if opponent not found in teams
    if [[ -z $TEAM_ID ]]
    then
      #insert opponent team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, opponent team named $OPPONENT
      fi
      #get new team_id
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
fi

WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

 INSERT_NAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$YEAR', '$ROUND', $WINNER_ID,  $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")     

done
