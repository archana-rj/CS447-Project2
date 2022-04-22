# CS447 Project 2: Space Rocket Game

The goal of this game is to shoot bullets at oncoming rocks until they are destroyed. Each time your bullet hits a rock, the size of the rock decreases until it is completely destroyed. If the rock hits the player before it is destroyed, the player incurs damage to their health. If the player keeps getting damaged, they will lose a life. In total, the player has 3 lives. Each time a life is lost, the player is respawned. If the player manages to destroy all the rocks before all their lives are lost, they win the game. If not, they lose the game and have to restart.
<br />
<br />
<br />
<p align="center">
  <img width="450" img height="450" alt="Screenshot 2022-04-21 at 8 17 34 PM" src="https://user-images.githubusercontent.com/66859238/164571313-29f43f6b-781c-48c7-886d-68cd3f3a8075.png">
&nbsp; &nbsp; &nbsp; &nbsp;
  <img width="450" img height="450" alt="Screenshot 2022-04-21 at 8 19 27 PM" src="https://user-images.githubusercontent.com/66859238/164571314-612308e0-303b-47a1-8d0f-14e1a1c4f9b4.png"> 
</p>
<br />
## The Player

The player will be able to rotate, accelerate, slow down, and fire
bullets. They can also be damaged or destroyed by the rocks. When
damaged, they will become temporarily invulnerable. When
destroyed, they will “respawn” or reappear after a short delay unless they’ve
run out of retries, in which case it’s a game over.

## The Bullets

The bullets are fired by the player with the B key to destroy rocks. When fired, they
travel in the direction the player is facing. They only travel a short
time before disappearing. 

## The Rocks

The rocks are the targets and hazards. There are three sizes:
large, medium, and small. 
The game starts with several large
rocks. When destroyed, they create two medium rocks; and
when medium rocks are destroyed, they create two small
rocks. 
When all rocks are destroyed, the player wins the
game.

The player starts with 5 health, represented by the blue and white bar
at the bottom of the screen is showing.

When rocks clash with the player, the player incurs damage to their health.
The damage amount is subtracted from their health.
When their health reaches 0, they disappear and lose a life.

Then, after a short delay:
  - If they still have lives left, they will respawn (revive, resurrect,
reappear, whatever).
  - If they don’t have lives left, it’s game over!



© 2016-2020 Jarrett Billingsley

