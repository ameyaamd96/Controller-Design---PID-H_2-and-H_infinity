# Controller-Design---PID-H_2-and-H_infinity
Lateral Control of Autonomous Vehicles. Designed PID, 𝐻2 and 𝐻∞ controllers and trade offs in design were studied upon for real-time implementation.

PID CONTROLLER DESIGN
The controller design using PID is a relatively extreme form of a phase lead-lag compensator design having one of the poles at origin and the other pole tending to infinity. The PI and the PD controller designs similar to PID are extreme cases of phase-lag and phase-lead compensators, respectively.

H_2 controller design
The H_2 controller is designed to minimize the H_2norm of the system.  For designing the H_2 controller, the Algebraic Ricatti equation was solved. Because of separation principle, dynamics for both the controller and the observer were obtained separately. 

H_∞ Controller design
The H_∞ controller is designed to minimize the H_∞  norm of the system. For the design of H_∞ controller, the H_2 problem was continued by taking the H_∞ norm of the H_2 controlled system as the upper bound for the bisection method in the controller design. Again because of the separation principle, dynamics for both the controller and the observer were obtained separately.


