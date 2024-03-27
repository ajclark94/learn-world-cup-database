#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# reset all data in db for testing purposes
echo $($PSQL "TRUNCATE teams, games")
echo $($PSQL "ALTER SEQUENCE teams_team_id_seq RESTART WITH 1")
echo $($PSQL "ALTER SEQUENCE games_game_id_seq RESTART WITH 1")
# read data from CSV file
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
#start loop
do
#get team_id of winners and insert to teams table if not already present
if [[ $WINNER != winner ]]
then
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
if [[ -z $WINNER_ID ]]
then
INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
if [[ $INSERT_WINNER == "INSERT 0 1" ]]
then
echo Inserted into teams, $WINNER
fi
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'") 
fi
fi
#get team_id of opponents and insert to teams table if not already present
if [[ $OPPONENT != opponent ]]
then
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
if [[ -z $OPPONENT_ID ]]
then
INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
then
echo Inserted into teams, $OPPONENT
fi
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
fi
fi
#Insert each row into games db
if [[ $YEAR != year ]]
then
INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
fi
done