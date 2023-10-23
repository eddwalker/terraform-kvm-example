# kubespray compatible ansible template to write ip adresses of nodes

[all]
%{ for str in allnodes ~}
${str}
%{ endfor ~}

[kube_control_plane]
%{ for str in masters ~}
${str}
%{ endfor ~}

[etcd]
%{ for str in masters ~}
${str}
%{ endfor ~}

[kube_node]
%{ for str in workers ~}
${str}
%{ endfor ~}

[k8s_cluster:children]
kube_control_plane
kube_node
