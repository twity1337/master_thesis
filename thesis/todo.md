- Kubeadm auf debian Bulsseye VM in Hyper-V installiert.  (2G RAM, 2 Prozesorkernen)
	- Dient als control-plane node
	- Swapping deaktiviert
	
	
- es ist notwendig, control-plane auf linux zu installieren, auf Windows gehen nur Worker-Nodes

Host:
- Powershell Command: (NAT)
`New-NetIPAddress -IPAddress 172.18.80.1 -PrefixLength 20 -InterfaceIndex 30`
`New-NetNat -Name OpenTwinClusterNAT -InternalIPInterfaceAddressPrefix 172.18.80.0/20` (Admin)


Linux-Master:
- Swap off
- Standard config generiert: `containerd config default > /etc/containerd/config.toml`
```
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
            SystemdCgroup = true
```

- systemd bei Containerd eingerichtet (in /etc/containerd/config.toml); containerd service neugestartet
- Kubeconfig auf SystemD gestellt

https://v1-23.docs.kubernetes.io/docs/tasks/administer-cluster/kubeadm/adding-windows-nodes/
- sudo kubeadm init --config kubeadm-config.yaml
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
 
- kubectl apply -f kube-flannel.yml
  

Windows-Node:
- Windows Server 2022 VM: `Set-VMProcessor -VMName "Windows Server 2022" -ExposeVirtualizationExtensions $true`
- `Add-WindowsFeature Containers,Hyper-V,Hyper-V-Tools,Hyper-V-PowerShell -Restart -IncludeManagementTools`
- `Add-MpPreference ...`
- `curl.exe -LO https://raw.githubusercontent.com/kubernetes-sigs/sig-windows-tools/master/kubeadm/scripts/PrepareNode.ps1`
`.\Install-Containerd.ps1 -ContainerDVersion 1.6.8`

- `curl.exe -LO https://raw.githubusercontent.com/kubernetes-sigs/sig-windows-tools/master/kubeadm/scripts/PrepareNode.ps1`
`.\PrepareNode.ps1 -KubernetesVersion v1.25.3 -ContainerRuntime containerD`

-- Irgendwo hier: `curl -L https://github.com/kubernetes-sigs/sig-windows-tools/releases/latest/download/kube-proxy.yml | sed 's/VERSION/v1.25.3/g' | kubectl apply -f -`

- kubeadm token create --print-join-command
- --cri-socket "npipe:////./pipe/containerd-containerd"


- crictl downloaden
- containerd downloaden
	- .\containerd.exe config default | Out-File "config.toml" -Encoding ascii



containerd, hyper-v, kubelet, nssm (non-sucking service manager)

- Join command mittels: sudo kubeadm token create --print-join-command





docker build -f .\session.Containerfile -t local.dev/opentwin-session:latest ..\Deployment\

docker save local.dev/opentwin-session:latest -o container.tar

ctr --namespace k8s.io image import .\container.tar
ctr --namespace k8s.io run --rm -t local.dev/opentwin-session:latest opentwin-session

echo Start:%time% &&^
docker build -f .\session.Containerfile -t local.dev/opentwin-session:latest ..\..\Deployment\ && ^
docker save local.dev/opentwin-session:latest -o container.tar && ^
ctr --namespace k8s.io image import .\container.tar  &&^
docker build -f .\globalsession.Containerfile -t local.dev/opentwin-globalsession:latest ..\..\Deployment\ && ^
docker save local.dev/opentwin-globalsession:latest -o container.tar && ^
ctr --namespace k8s.io image import .\container.tar  &&^
docker build -f .\authorisation.Containerfile -t local.dev/opentwin-authorisation:latest ..\..\Deployment\ && ^
docker save local.dev/opentwin-authorisation:latest -o container.tar && ^
ctr --namespace k8s.io image import .\container.tar  &&^
del container.tar &&^
echo End:%time%


