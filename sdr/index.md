## The SDR stuff

### Argo
Argo is the management interface for the SDR.  This site is only available to privileged library affiliated users and gives them an administrators UI. Argo is a frontend to the functions provided by the dor-services-app.

### dor-services-app (DSA)
This is the internal API for managing the SDR.  It has a direct connection to the persistence layer and all other systems write/read from the persisted data through DSA. 

### Google Books
Automatically downloads books we have sent off to google for scanning.  This provides a minimal UI for monitoring and is only used by the infrastructure team and Andrew.  Google books are deposited as a single ZIP file with all the images.  They are kept dark, as many of them are not out of copyright. The downloading job uses the SDR-API to deposit the files.

### SDR-API
This is an external facing API. It is not totally complete as it doesn't produce derivatives for book/image types and it doesn't yet have fined grained authorization.  Currently all of the h2 and GoogleBooks deposits flow through this API.  This in turn communicates with dor-services-app on the back end

### ETD
Students can deposit thesis and dissertations into the repository

### h2
Stanford affiliated users can self deposit. The previous iteration of this software was called "Hydrus", the newest version is "h2".

### dor-indexing-app
Creates a solr representation of the objects and writes it to Solr. This solr index is used for Argo and for dor-services-app since the Fedora 3 repository has no query capabilities.

### Pre-assembly
### preservation
### robots
### WAS
### GIS
