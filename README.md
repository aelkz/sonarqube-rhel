### NOTES

You may want to check the following if you get the error about virtual memory:

- [1]: max virtual memory areas vm.max_map_count [65530] is too low, **increase to at least** [262144]

You'll need to apply some configuration on the hosts that provides the CICD environment:

```
oc get nodes --show-labels | grep cicd*
```

The default value is **65530** accordingly with the docs: https://docs.sonarqube.org/latest/requirements/requirements/

##### External References

[Docker image Customization](https://hub.docker.com/_/sonarqube)

[What is the parameter "max_map_count" and does it affect the server performance?](https://access.redhat.com/solutions/99913)
