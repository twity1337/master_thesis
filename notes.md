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