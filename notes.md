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



#  hcs::CreateComputeSystem flannel-hostprocess: The system cannot find the file specified.: unknown
Irgendwas stimmt mit Dockerfile nicht.





## flannel: OS wird nicht unterstützt
### Eigener Build
kubectl apply -f flannel-overlay.yml
kubectl apply -f kube-flannel.yml

https://github.com/kubernetes-sigs/sig-windows-tools/blob/master/hostprocess/flannel/build.sh


AUf  Linux controlplane:
- Neuste Version von Docker installieren (wegen buildx)
- dateien von sig-windows-tools repo kopieren (container build context) 

cd ./hostprocess/flannel/
docker buildx create --name img-builder --use --platform windows/amd64
docker buildx build --platform windows/amd64 --output=type=registry --pull --build-arg=flannelVersion="v0.13.0" -f Dockerfile -t local.dev/sigwindowstools/flannel:v0.13.0-hostprocess .
docker buildx build --platform windows/amd64 --output=type=registry --pull --build-arg=k8sVersion="v1.25.3" -f Dockerfile -t local.dev/sigwindowstools/kube-proxy:v1.25.3-flannel-hostprocess .

>> sudo docker buildx build --platform windows/amd64 --output=type=oci,dest=flannel.tar --pull --build-arg=flannelVersion="v0.13.0" -f Dockerfile -t local.dev/sigwindowstools/flannel:v0.13.0-hostprocess .
scp user@172.18.80.110:~/build-flanneld-sigwindowstools/flannel.tar C:\Users\Administrator\Downloads\flannel.tar
ctr -n k8s.io image import .\flannel.tar

# Calico
- kubeadm-flags.env --node-ip gesetzt (172.18.80.100)

$env:KUBECONFIG="/etc/kubernetes/kubelet.conf"

cd C:\k\
New-Item -Name config -ItemType SymbolicLink -Value "C:\etc\kubernetes\kubelet.conf"




apiVersion: v1
kind: Secret
metadata:
  name: calico-node-token
  namespace: kube-system
  annotations:
    kubernetes.io/service-account.name: calico-node
type: kubernetes.io/service-account-token






## Solved Problems
- Hostprocess container --> OS  Version == Container Version   -> Registry
- Containerd not possible to build an image, need to  build with docker, and shift to namespace k8s.io (by export/import)
- Flannel --> Hyper-V? VPN used same IP?  -> Local cluster. Documentation from SIG-Windows-Tools used
- Flannel under Windows -> Error for RBAC fixed
- Containerd & Docker - Containerfile spec is same, but differently interpreted. Error if CMD is defined in JSON format under Containerd

- Error reporting and logging extended for OpenTwin
- Network binding of GlobalSessionService has to be on 0.0.0.0k, otherwise it's not reachable from outside?
- Architecture, exception handling: "Rust cannot catch foreign exceptions", Window immediately closes on error --> fixed


-- Exception handling open-twin
-- GSS und AUTH außerhalb von Docker laufen lassen.


- Error: failed to create containerd task: failed to create shim task: hcs::CreateComputeSystem kube-flannel: "The directory name is invalid."
https://stackoverflow.com/questions/74799620/kubernetes-windows-worker-node-addition-failed-to-create-containerd-task-hcss

- Mongodb läuft nicht unter windows - keine Initialisierungsskripte

- AuthorisationService - Password in command line argument ist platform/client abhängig (relevant bei Encrypt/Decrypt)

MongoDB connection: 
	 + "&tlsAllowInvalidHostnames=true&tlsCertificateKeyFile=E:\\OpenTwin\\Repo\\Deployment\\Certificates\\certificateKeyFile.pem"

- [SSL Certification verification failed: hostname doesn't match certificate calling hello on '192.168.0.39:27017']: generic server error
	- tlsAllowInvalidHostnames=true
	
- [Failed to receive length header from server. calling hello on '192.168.0.39:27017']: generic server error
   - Keyfile mit übergeben
   
[Failed to initialize security context, error code: 0x80090331: Incorrect function. calling hello on '192.168.0.39:27017']: generic server error



Bei MongoDb auf Physical machine: 
-- Authorisation: docker logs container-opentwin-authorisation-1
-> uiFrontend (von Host) -> Request auf AUTH in Docker (One-Way-TLS)/(Ping)
> Error handling request: error shutting down connection: An established connection was aborted by the software in your host machine. (os error 10053)

(Request auf GSS funktioniert stattdessen)


- mTLS: OpenTwin neue Zertifikate auf Container erstellen mittels Skript
--> Hostnames in json erweitern (localhost, 127.0.0.1)


Mongo kann nicht in Docker liegen, weil:
- GSS auf MongoDB zugreift und Launcher greift auch auf MongoDB zu.
- Docker link: Würde ermöglichen, dass Container drauf zugreifen kann, dann stimmt aber übermittelte Adresse von AUTH nicht mehr und uiFrontend kann nicht drauf zugreifen
- Localhost: Würde ermöglichen, dass uiFrontend zugreifen kann, dann kann aber AUTH nicht mehr zugreifen, weil localhost für AUTH der eigene Container ist.


https://github.com/docker-library/mongo/discussions/599
- Automatisierte Einrichtung von MongoDB auf Windows nicht möglich. (Init-Skripte funktionieren noch nicht in Docker)

Zugriff von Docker auf Rechner außerhalb nicht möglich  -> Kann DB-Server auf Host liegen? Oder muss der auch auf Docker gehostet werden?