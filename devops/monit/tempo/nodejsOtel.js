import { createRequire } from "module";
const require = createRequire(import.meta.url);

const { NodeSDK } = require("@opentelemetry/sdk-node");
const { OTLPTraceExporter } = require("@opentelemetry/exporter-trace-otlp-http");
const { HttpInstrumentation } = require("@opentelemetry/instrumentation-http");
const { ExpressInstrumentation } = require("@opentelemetry/instrumentation-express");
const { MySQL2Instrumentation } = require("@opentelemetry/instrumentation-mysql2");

const traceExporter = new OTLPTraceExporter({
  url: "http://127.0.0.1:4318/v1/traces",
});

const sdk = new NodeSDK({
  serviceName: "test",
  traceExporter,
  instrumentations: [new HttpInstrumentation(), new ExpressInstrumentation(), new MySQL2Instrumentation()],
});

sdk.start();
console.log("OpenTelemetry tracing initialized");

process.on("SIGTERM", () => {
  sdk
    .shutdown()
    .then(() => console.log("OpenTelemetry SDK shut down"))
    .catch((err) => console.error("Error shutting down OTel SDK", err))
    .finally(() => process.exit(0));
});
