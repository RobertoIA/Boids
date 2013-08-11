Boids
=
[Boids](http://en.wikipedia.org/wiki/Boids) implementation, using Processing.
Implements flocking, simple predator-prey interactions and feeding mechanics.

###Lifecycle
Boids go hungry over time. If they can't find food, they will emit light pulses as a complain. If they starve, they will become predators.

![](http://i.minus.com/ibgpEQhfVx3kSO.gif)

Hungry boids will feed on food pellets.

![](http://i.minus.com/iuYLRjh2rM5AH.gif)

Hungry predators will consume nearby boids, injuring and eventually killing them.

![](http://i.minus.com/ijrX2j0KmQXKv.gif)

### Controls
* Holding the left mouse button and dragging it on the window spawns boids.
* Rigth clicking on the window spawns food on that point.
* Predators appear naturally if you let the boids starve.