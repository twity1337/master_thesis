# Title
- Realization of distributed system design for a multi-level microservice architecture application
- Containerized multi-level deployment for a distributed adaptive microservice application



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
	- Runs on every node computer (Daemonset?)
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
- Share GPU between pods?


# Goals
1. GlobalSession creates and provisions new Session services
1. Directory service communicates with SessionService to tell where to start Microservice

# Open questions
- What does Directory service do? 
- What is already done? Global directory?
- Kubernetes API vs. Serverless




# Time schedule
- 14.10.2022 Start-> Setup Kubernetes and Simple Pods (on Windows)
- 28.10.2022 Containerize OpenTwin (Reporting to StdOut (Optional), Probes, Windows Containers)
- 07.12.2022 Code changes: Automatic replication based on kubernetes API
- 01.02.2022 Testing / Bugfixing
- 27.02.2023 Finalize Writing
- 10.03.2023 Proofreading
- ~17.03.2023 Submission / End


# References
https://medium.com/swlh/how-to-create-kubernetes-objects-using-kubernetes-api-1baea18f54c1
