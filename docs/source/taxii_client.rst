CTI TAXII Client
================

The cti-taxii-client library was developed by MITRE and it is a minimal client implementation for the TAXII 2.0 server.
A TAXII server is an open-source module designed to serve STIX 2.0 content in compliance with the TAXII 2.0 specification.
Written in JavaScript, a TAXII server takes advantage of Node.js's asynchronous I/O model to handle incoming connections, allowing the server to handle connections smoothly under load.

What is TAXII?
##############

Trusted Automated Exchange of Intelligence Information (TAXII™) is an application protocol for exchanging CTI over HTTPS. ​TAXII defines a RESTful API (a set of services and message exchanges) and a set of requirements for TAXII Clients and Servers.
As depicted below, TAXII defines two primary services to support a variety of common sharing models:

* **Collection** - A Collection is an interface to a logical repository of CTI objects provided by a TAXII Server that allows a producer to host a set of CTI data that can be requested by consumers: TAXII Clients and Servers exchange information in a request-response model.
* **Channel** - Maintained by a TAXII Server, a Channel allows producers to push data to many consumers and consumers to receive data from many producers: TAXII Clients exchange information with other TAXII Clients in a publish-subscribe model. Note: The TAXII 2.0 specification reserves the keywords required for Channels but does not specify Channel services. Channels and their services will be defined in a later version of TAXII.

TAXII Client & ATT&CK
#####################

As mentioned before, on May 14th, 2018, the ATT&CK team announced that all of MITRE’s Adversarial Tactics, Techniques, and Common Knowledge content, including ATT&CK for Enterprise , PRE-ATT&CK™, and ATT&CK for Mobile, was going to be available via their own TAXII 2.0 server in STIX 2.0 format.
The following four classes are available via the taxii2-client library and can be used to interact with ATT&CK's public TAXII server:

* Server
* ApiRoot
* Collection
* Status

Query ATT&CK
############

ATT&CK users can use the initial ``Server`` class to instantiate a server object pointing to the framework's public TAXII server URL ``https://cti-taxii.mitre.org/taxii/``

.. code-block:: python

    >>> from taxii2client.v20 import Server
    >>> server = Server("https://cti-taxii.mitre.org/taxii/")

The server variable can then be used to access initial metadata about the ATT&CK TAXII server:

.. code-block:: python

    >>> server.title
    'CTI TAXII server'

    >>> server.description
    'This TAXII server contains a listing of ATT&CK domain collections expressed as STIX, including PRE-ATT&CK, ATT&CK for Enterprise, and ATT&CK Mobile.'

    >>> server.contact
    'attack@mitre.org'

    >>> server.url
    'https://cti-taxii.mitre.org/taxii/'

In addition, available ``API Roots`` can be referenced from the server object.
API Roots are logical groupings of TAXII Channels and Collections and can be thought of as instances of the TAXII API available at different URLs, where each API Root is the “root” URL of that particular instance of the TAXII API:

.. code-block:: python

    >>> server.api_roots
    [<taxii2client.ApiRoot object at 0x10519e7b8>]

    >>> api_root = server.api_roots[0]
    <taxii2client.ApiRoot object at 0x10519e7b8>

As we can see above, there is only one ``API root`` instance available, and information about it can be accessed the following way:

.. code-block:: python

    >>> api_root.title
    'stix'

    >>> api_root.url
    'https://cti-taxii.mitre.org/stix/'

    api_root.versions
    ['taxii-2.0']

If you explore the additional attributes and methods available in the only api root instance, there is a ``collections`` attribute:

.. code-block:: python

    >>> api_root.
    api_root.close(                api_root.custom_properties     api_root.get_status(           api_root.refresh(              api_root.refresh_information(  api_root.url                   
    api_root.collections           api_root.description           api_root.max_content_length    api_root.refresh_collections(  api_root.title                 api_root.versions              

The ``collections`` attribute can then be used and get more information about them via their respective available properties:

.. code-block:: python

    >>> api_root.collections
    [<taxii2client.Collection object at 0x105ba1dd8>, <taxii2client.Collection object at 0x105b855f8>, <taxii2client.Collection object at 0x105b85908>]

    >>> api_root.collections[0]
    <taxii2client.Collection object at 0x105ba1dd8>

    >>> api_root.collections[0].title
    'Enterprise ATT&CK'

    >>> api_root.collections[0].id
    '95ecc380-afe9-11e4-9b6c-751b66dd541e'

    >>> api_root.collections[0].description
    'This data collection holds STIX objects from Enterprise ATT&CK'

    >>> api_root.collections[0].url
    'https://cti-taxii.mitre.org/stix/collections/95ecc380-afe9-11e4-9b6c-751b66dd541e/'

    >>> api_root.collections[0].objects_url
    'https://cti-taxii.mitre.org/stix/collections/95ecc380-afe9-11e4-9b6c-751b66dd541e/objects/'
 
A ``for`` loop can be used to print all the collections available in the ATT&CK public TAXII server with their respective names and ids.
As we can see below, there are three collections available in the TAXII server, and they are mapped to ATT&CK domains:

.. code-block:: python

    >>> api_root.collections[0]
    >>> for collection in api_root.collections:
    ...     print(collection.title + ": " + collection.id)

    >>> Enterprise ATT&CK: 95ecc380-afe9-11e4-9b6c-751b66dd541e
    >>> PRE-ATT&CK: 062767bd-02d2-4b72-84ba-56caef0f8658
    >>> Mobile ATT&CK: 2f669986-b40b-4423-b720-4396ca6a462b

We can then use the ``Collection`` class to instantiate TAXII2 Collection objects for each available collection:

.. code-block:: python

    >>> from taxii2client.v20 import Collection

    >>> ENTERPRISE_COLLECTION = Collection(api_root.collections[0].url)
    >>> PRE_COLLECTION = Collection(api_root.collections[1].url)
    >>> MOBILE_COLLECTION = Collection(api_root.collections[2].url)

Finally we can use the ``get_object`` method from the ``Collection`` class and retrive a specific object from the ATT&CK Enterprise Matrix.
Let's say we want to retrieve ``technique 1066``. We will need to provide the object id ``attack-pattern--00d0b012-8a03-410e-95de-5826bf542de6`` that corresponds to T1066.
You can use the `MITRE cti GitHub repo <https://github.com/mitre/cti/blob/master/enterprise-attack/attack-pattern/attack-pattern--00d0b012-8a03-410e-95de-5826bf542de6.json>`_ to confirm the technique-id mapping:

.. code-block:: python

    >>> T1066 = ENTERPRISE_COLLECTION.get_object("attack-pattern--00d0b012-8a03-410e-95de-5826bf542de6")
    >>> T1066
    {
        'type': 'bundle', 
        'id': 'bundle--04349067-1887-4a20-83e8-4e44c35a9e2f',
        'spec_version': '2.0',
        'objects':
        [{
            'id': 'attack-pattern--00d0b012-8a03-410e-95de-5826bf542de6',
            'created_by_ref': 'identity--c78cb6e5-0c4b-4611-8297-d1b8b55e40b5',
            'name': 'Indicator Removal from Tools',
            'description': "If a malicious tool is detected and quarantined or otherwise curtailed, an adversary may be able to determine why the malicious tool was detected (the indicator), modify the tool by removing the indicator, and use the updated version that is no longer detected by the target's defensive systems or subsequent targets that may use similar systems.\n\nA good example of this is when malware is detected with a file signature and quarantined by anti-virus software. An adversary who can determine that the malware was quarantined because of its file signature may use [Software Packing](https://attack.mitre.org/techniques/T1045) or otherwise modify the file so it has a different signature, and then re-use the malware.",
            'external_references': 
            [{
                'external_id': 'T1066',
                'url': 'https://attack.mitre.org/techniques/T1066',
                'source_name': 'mitre-attack'
            }],
            'object_marking_refs': ['marking-definition--fa42a846-8d90-4e51-bc29-71d5b4802168'],
            'type': 'attack-pattern',
            'kill_chain_phases': 
            [{
                'phase_name': 'defense-evasion',
                'kill_chain_name': 'mitre-attack'
            }],
            'modified': '2018-10-17T00:14:20.652Z',
            'created': '2017-05-31T21:30:54.176Z',
            'x_mitre_version': '1.0',
            'x_mitre_data_sources': ['Process use of network', 'Process monitoring', 'Process command-line parameters', 'Anti-virus', 'Binary file metadata'],
            'x_mitre_defense_bypassed': ['Log analysis', 'Host intrusion prevention systems', 'Anti-virus'],
            'x_mitre_detection': 'The first detection of a malicious tool may trigger an anti-virus or other security tool alert. Similar events may also occur at the boundary through network IDS, email scanning appliance, etc. The initial detection should be treated as an indication of a potentially more invasive intrusion. The alerting system should be thoroughly investigated beyond that initial alert for activity that was not detected. Adversaries may continue with an operation, assuming that individual events like an anti-virus detect will not be investigated or that an analyst will not be able to conclusively link that event to other activity occurring on the network.',
            'x_mitre_platforms': ['Linux', 'macOS', 'Windows']
        }]
    }

As you can see above, we were able to get information about a specific technique from the ATT&CK public TAXII server.
However, it would be good to filter our collection request by specific STIX objects without relying on an object ID only.
This is where the next library cti-python-stix2 comes into play.

References
##########

* https://www.mitre.org/capabilities/cybersecurity/overview/cybersecurity-blog/attck%E2%84%A2-content-available-in-stix%E2%84%A2-20-via
* https://taxii2client.readthedocs.io/en/latest/api/api_reference.html
* https://github.com/oasis-open/cti-taxii-client
* https://oasis-open.github.io/cti-documentation/taxii/intro.html
* https://github.com/mitre/cti/blob/master/enterprise-attack/attack-pattern/attack-pattern--00d0b012-8a03-410e-95de-5826bf542de6.json