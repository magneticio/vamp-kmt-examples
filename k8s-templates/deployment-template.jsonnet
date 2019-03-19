local env = std.extVar("__ksonnet/environments");
local params = std.extVar("__ksonnet/params").components["@@componentName@@"];

local k = import "k.libsonnet";

local deployment = k.apps.v1beta1.deployment;

local name = std.join("-", [params.name, params.tag]);

local labels = {
@@labels@@
};

local container = k.apps.v1beta1.deployment.mixin.spec.template.spec.containersType;

local containerImage = std.join(":", [params.image, params.tag]);

local containerPort = container.portsType;

local targetPort = params.containerPort;

local containerSpec = container
  .new(params.name, containerImage)
  .withPorts(containerPort.new(targetPort))
  @@withEnv@@
;

local appDeployment = deployment
  .new(
    name,
    params.replicas,
    containerSpec,
    labels);

k.core.v1.list.new([appDeployment])