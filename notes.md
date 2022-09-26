# Architecture
- Services "Auth", "Session", "Global directory" and "Database" always run
- Database: MongoDB
- Session service starts Worker services (MS)
- Global/Local Directory service
	- Assigns Session services 
- Proprietary HTTP-JSON communication protocol? (Not RESTful?)
- RUST Tokyo web server
- Relay: Opens Websocket to UI/Client
- Global session: 
	- Session services register at Global session service
	- replies with data from 
- Local directory:
	- Runs on every node computer
	- Decides on which node to start new Microservice based on hardware requirements
- Global directory: Knows local directory services, decides where to start new local directory

# Challenges

## Architecture challenges
- Auto provisioning of local directory service and session services on nodes


## Kubernetes challenges
- OpenShift?
- Services consume much memory (not a real challenge)
- Auto provisioning
- Flexible kubernetes (decide based on hardware requirements, global directory service)
- Container for windows
	- each process in one container
	- Windows...
- Enable Liveness/Active probes per container


# Goals
1. GlobalSession creates and provisions new Session services
1. Directory service communicates with SessionService to tell where to start Microservice

# Open questions
- What does Directory service do? 
- What is already done? Global directory?