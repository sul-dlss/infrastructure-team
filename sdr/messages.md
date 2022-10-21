# Messages

Use of messages within SDR are detailed herein.

## Publishers

* [dor-services-app](/sdr#dor-services-app) publishes messages to
  * the `sdr.objects.created` topic [when an item is created](https://github.com/sul-dlss/dor-services-app/blob/main/app/services/notifications/object_created.rb)
  * the `sdr.objects.updated` topic [when an item is updated](https://github.com/sul-dlss/dor-services-app/blob/main/app/services/notifications/object_updated.rb)
  * the `sdr.objects.deleted` topic [when an item is deleted](https://github.com/sul-dlss/dor-services-app/blob/main/app/services/notifications/object_deleted.rb)
  * the `sdr.objects.embargo_lifted` topic [when an embargo is lifted](https://github.com/sul-dlss/dor-services-app/blob/main/app/services/notifications/embargo_lifted.rb)
  * the `sdr.objects.event` topic
* [workflow-server-rails](/sdr#workflow-server) publishes messages to the `sdr.workflow` topic [when an workflow step changes state](https://github.com/sul-dlss/workflow-server-rails/blob/main/app/services/send_rabbitmq_message.rb)
* [preservation_catalog](/sdr#preservation-catalog) publishes messages to the `sdr.objects.event` topic [when a druid version is replicated](https://github.com/sul-dlss/preservation_catalog/blob/main/app/jobs/results_recorder_job.rb), and [when preservation audits complete (whether success or failure)](https://github.com/sul-dlss/preservation_catalog/blob/main/app/services/reporters/event_service_reporter.rb).

## Topics

* `sdr.workflow` is used for workflow transitions.  The routing key is composed of the step name and status, which for example allows subscribers to bind to `end-accession.completed` in order to know when an item has finished accessioning.
* `sdr.objects.created` is used for newly created (registered) objects. The routing key is the project tag. This enables subscribers to filter messages pertaining to specific projects (e.g., "h2").
* `sdr.objects.updated` is used for updated objects. The routing key is the first project tag for items and collections or the string `SDR` for administrative policies. This enables subscribers to filter messages pertaining to specific projects (e.g., "h2").
* `sdr.objects.deleted` is used for deleted objects. The routing key is the first project tag for items and collections or the string `SDR` for administrative policies. This enables subscribers to filter messages pertaining to specific projects (e.g., "h2").
* `sdr.embargo_lifted` is used for an embargo that is lifted. The routing key is the first project tag for items and collections or the string `SDR` for administrative policies. This enables subscribers to filter messages pertaining to specific projects (e.g., "h2").
* `sdr.objects.event` is used for recording events. The routing key is the event type.

## Subscribers

* [H2](/sdr#H2) subscribes to the `sdr.workflow`, `sdr.objects.embargo_lifted`, and `sdr.objects.created` topics
* [dor-indexing-app](index#dor-indexing-app) subscribes to the `sdr.workflow`, `sdr.objects.updated`, `sdr.objects.deleted`, and `sdr.objects.created` topics
* [dor-services-app](/sdr#dor-services-app) subscribes to the `sdr.objects.event` topic

Subscribers bind queues to topics in order to asynchronously act on messages, and said binding happens in SDR apps by running a dedicated rake task, e.g.:
https://github.com/sul-dlss/happy-heron/blob/main/lib/tasks/rabbitmq.rake
