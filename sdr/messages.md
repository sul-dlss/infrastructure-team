# Messages

The SDR passes RabbitMQ messages for the following use cases:

* [H2](/sdr#H2) is notified when an item is registered
* [H2](/sdr#H2) is notified when an item is deposited
* [H2](/sdr#H2) is notified when an embargo is lifted
* [dor-indexing-app](index#dor-indexing-app) is notified when an item needs to be indexed or when it has been deleted

These messages are produced by:

* [dor-services-app](/sdr#dor-services-app)  sends messages when an item is updated: https://github.com/sul-dlss/dor-services-app/blob/e8d7595f96c62b8b4a7c13a98618c2c66a521504/app/services/notifications/object_updated.rb
* [dor-services-app](/sdr#dor-services-app) sends messages when an embargo is lifted: https://github.com/sul-dlss/dor-services-app/blob/604a041dbb8d19735ee1fcd6fc0445ff614e5593/app/services/embargo_release_service.rb#L55
* [workflow-server-rails](/sdr#workflow-server) sends messages when an workflow step changes state: https://github.com/sul-dlss/workflow-server-rails/blob/e328f768446aa37dcd067d830f9833c7c4f36c57/app/services/send_update_message.rb#L9

The topics are:

* `sdr.workflow` for workflow transitions.  The routing key is composed of the step name and status, which allows consumers to bind to: `end-accession.completed` in order to know when an item has been deposited.
* `sdr.objects.created` for newly created (registered) objects. The routing key is the project tag.  This enables consumers to filter just the objets affiliated with specific projects (e.g. "h2")
* `sdr.embargo_lifted` for an embargo that is lifted. The routing key is the project tag.  This enables consumers to filter just the objets affiliated with specific projects (e.g. "h2")

The binding of queues to topics happens in H2 by running this rake task:
https://github.com/sul-dlss/happy-heron/blob/main/lib/tasks/rabbitmq.rake
