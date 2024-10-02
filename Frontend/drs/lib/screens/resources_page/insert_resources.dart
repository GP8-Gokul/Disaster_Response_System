

Future<Map<String, String>?> insertResourceDialog(
    BuildContext context, Function fetchResources, response) async {
  Completer<Map<String, String>?> completer = Completer();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController resourceNameController = TextEditingController();
      TextEditingController resourceTypeController = TextEditingController();
      TextEditingController resourceDescriptionController = TextEditingController();
      TextEditingController resourceQuantitycontroller=TextEditingController();
    }
    }  
