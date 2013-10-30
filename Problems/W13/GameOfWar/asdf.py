import itertools
import random

cards = ['2','3','4','5','6','7','8','9','10','J','Q','K','A']
suits = ['H','S','C','D']
deck = [a+b for (a,b) in itertools.product(cards, suits)]
d1 = random.sample(deck, random.randint(1,len(deck)))
for a in d1:
    deck.remove(a)
print ' '.join(d1)
print ' '.join(deck)
