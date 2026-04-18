oc new-project checker
oc new-project database

cat <<EOF | kubectl apply -f -
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: deny-all
  namespace: database  
spec:
  podSelector: {}
EOF
cat <<EOF | oc apply -f -

apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: mysql
  name: mysql
  namespace: database
spec:
  replicas: 1
  selector:
    matchLabels:
      network.openshift.io/policy-group: mysql
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        network.openshift.io/policy-group: mysql
    spec :
      containers:
      - image: registry.ocp4.example.com:8443/rhel9/mysql-80:latest
        name: mysq1-80-rhe17
        env:
          - name: MYSQL_ROOT_PASSWORD
            value: redhat
EOF

cat <<EOF | oc apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: mysql
  name: mysql-client
  namespace: checker
spec:
  replicas: 1
  selector:
    matchLabels:
      deployment-mysql: client
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        deployment-mysql: client
    spec:
      containers:
      - image: registry.ocp4.example.com:8443/rhscl/mysql-80-rhel7:latest
        name: mysql-80-rhe17
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: redhat	  
EOF
