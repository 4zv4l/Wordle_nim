## Wordle game in Nim !
##
## How to play
## ===========
##
## Try to guess the word :)
##
## red means that the letter is not in the word
## blue means the letter is in the word but wrong place
## green, letter is in the word and at the right place

import os
import terminal
from strformat import `&`
from strutils import split
from random import randomize, sample

proc usage() =
  ## show how to play
  echo """ Rules:
                - You have 5 guesses
                - You can only guess using 5 letters words
                - You can only guess using lowercase letters
                - Green means correct at the right position
                - Blue means correct at the wrong position
                - Red means incorrect
                - type "exit" to quit

        Give a filename in argument to have more words

        Good luck!"""

proc getWordFromCode(): string =
  ## return a random word builtin the code
  let words = [
        "apple",
        "music",
        "thing",
        "child",
        "night",
        "world",
        "house",
        "water",
        "heart",
        "light",
        "sound",
        "place",
        "right",
        "black",
        "white",
        "green",
        "happy",
  ]
  return sample(words)


proc getWordFromFile(filename: string): string =
  ## return a random word from a file given in argument
  try:
    let content = readfile(filename)
    let each_line = content.split('\n')
    return sample(each_line)
  except:
    return getWordFromCode()

proc checkLetters(guess, secret: string) =
  ## check and print letters in the right color
  for i, c in guess:
    if guess[i] == secret[i]:
      stdout.styledWrite(fgGreen, &"{c}")
    elif secret.contains(c):
      stdout.styledWrite(fgBlue, &"{c}")
    else:
      stdout.styledWrite(fgRed, &"{c}")
  echo ""

proc getGuess(prompt, secret: string): string =
  ## ask for a guess to the user
  var guess = ""
  while(guess == ""):
    stdout.write "guess> "
    guess = readline(stdin)
    if guess.len != secret.len:
      echo "Not the same length as the secret word.."
      echo &"secret word's length is {secret.len}"
      guess = ""
  return guess

proc play(secret: string): bool =
  ## main loop of a game
  let rounds = 5
  for round in 1..rounds:
    let guess = getGuess("guess> ", secret)
    checkLetters(guess, secret)
    if guess == secret:
      return true
  return false

when isMainModule:
  # show the rules
  usage()
  # init the randomizer
  randomize()
  # get the secret word
  var secret: string ## word to guess during the game
  if paramCount() == 1:
    secret = getWordFromFile(paramStr(1))
  else:
    secret = getWordFromCode()
  # play and check if winner or loser
  var is_winner: bool = play(secret) ## boolean on either you win or lose
  if is_winner:
    echo "Congrats !!!"
  else:
    echo &"You lose..the word was {secret}"
