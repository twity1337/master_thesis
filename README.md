# Containerized multi-level deployment for a distributed adaptive microservice application - a master thesis
This repository contains the LaTeX document of my Master Thesis in Winter Term 2022/2023.

> **Note**    
> The repository is marked as archived, because the thesis was finalised and submitted on 17 March 2023. The result was a very satisfying mark :)


## Abstract
This thesis explores the feasibility of deploying a Windows based microservice application using Kubernetes. It is showcased on the basis of OpenTwin, which is an application for computer aided design and physics simulation. OpenTwin is a distributed application where the computations can be performed server-side, while the operation by the user stays client-side.
It turns out, that deploying the application is challenging. Some changes on the application itself have to be done, especially in respect of the mutual authentication that comes to use. Further, finding information for setting up Windows based Kubernetes clusters is not as easy as it seems. A problem was the ongoing switch from Hyper-V isolation to process isolation, because the new technology is not yet supported throughout the application landscape of Kubernetes.
Thus, the thesis provides value for a rather unexplored field, because the usage of Windows containers for deployment is not well explored yet.
