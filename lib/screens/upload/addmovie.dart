import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movieboxclone/styles/snack_bar.dart';

class Upload extends StatefulWidget {
  const Upload({super.key});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _fileExtensionController = TextEditingController();
  final _defaultFileNameController = TextEditingController();
  final _dialogTitleController = TextEditingController();
  final _initialDirectoryController = TextEditingController();

  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  final bool _lockParentWindow = false;
  bool _userAborted = false;
  // final bool _multipick = false;
  // final FileType _pickingType = FileType.image;

  String _movieTitle = '';
  String _movieDescription = '';
  String _downloadlink = '';
  String _youtubeTrailerLink = '';
  final String _movieImg = '';
  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      // Perform the login action here, e.g., send the email and password to your server
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Logging in...')));
    }
  }

  @override
  void initState() {
    super.initState();
    _fileExtensionController
        .addListener(() => _extension = _fileExtensionController.text);
  }

  void _pickFiles() async {
    _resetState();
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        allowCompression: false,
        type: FileType.image,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
        dialogTitle: _dialogTitleController.text,
        initialDirectory: _initialDirectoryController.text,
        lockParentWindow: _lockParentWindow,
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
    });
  }

  void _clearCachedFiles() async {
    _resetState();
    try {
      bool? result = await FilePicker.platform.clearTemporaryFiles();
      if (result != null) {
        String error = result
            ? 'Temporary files removed with success'
            : 'Failed to clean temporary files';
        hideSnackBar();
      }
      showsnackBar('Failed to clean temporary files');
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _selectFolder() async {
    _resetState();

    try {
      String? path = await FilePicker.platform.getDirectoryPath(
        dialogTitle: _dialogTitleController.text,
        initialDirectory: _initialDirectoryController.text,
        lockParentWindow: _lockParentWindow,
      );
      setState(() {
        _directoryPath = path;
        _userAborted = path == null;
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveFile() async {
    _resetState();
    try {
      String? fileName = await FilePicker.platform.saveFile(
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
        type: FileType.image,
        dialogTitle: _dialogTitleController.text,
        fileName: _defaultFileNameController.text,
        initialDirectory: _initialDirectoryController.text,
        lockParentWindow: _lockParentWindow,
      );
      setState(() {
        _saveAsFileName = fileName;
        _userAborted = fileName == null;
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _logException(String message) {
    print(message);
    hideSnackBar();
    showsnackBar(message);
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload a movie"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                width: 120,
                child: FloatingActionButton.extended(
                    onPressed: () => _pickFiles(),
                    label: const Text('Pick file'),
                    icon: const Icon(Icons.description)),
              ),
              SizedBox(
                width: 200,
                child: FloatingActionButton.extended(
                  onPressed: () => _clearCachedFiles(),
                  label: const Text('Clear temporary files'),
                  icon: const Icon(Icons.delete_forever),
                ),
              ),
              SizedBox(
                width: 120,
                child: FloatingActionButton.extended(
                  onPressed: () => _selectFolder(),
                  label: const Text('Pick folder'),
                  icon: const Icon(Icons.folder),
                ),
              ),
              SizedBox(
                width: 120,
                child: FloatingActionButton.extended(
                  onPressed: () => _saveFile(),
                  label: const Text('Save file'),
                  icon: const Icon(Icons.save_as),
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Movie Title',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the movie Title';
                  }

                  return null;
                },
                onSaved: (value) => _movieTitle = value!,
              ),
              const SizedBox(height: 16.0),
              const Text(
                'File Picker Result',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Builder(
                builder: (BuildContext context) => _isLoading
                    ? const Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 40.0,
                                ),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        ],
                      )
                    : _userAborted
                        ? const Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: SizedBox(
                                    width: 300,
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.error_outline,
                                      ),
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 40.0),
                                      title: Text(
                                        'User has aborted the dialog',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : _directoryPath != null
                            ? ListTile(
                                title: const Text('Directory path'),
                                subtitle: Text(_directoryPath!),
                              )
                            : _paths != null
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20.0,
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.50,
                                    child: Scrollbar(
                                        child: ListView.separated(
                                      itemCount:
                                          _paths != null && _paths!.isNotEmpty
                                              ? _paths!.length
                                              : 1,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final bool isMultiPath =
                                            _paths != null &&
                                                _paths!.isNotEmpty;
                                        final String name =
                                            'File $index: ${isMultiPath ? _paths!.map((e) => e.name).toList()[index] : _fileName ?? '...'}';
                                        final path = kIsWeb
                                            ? null
                                            : _paths!
                                                .map((e) => e.path)
                                                .toList()[index]
                                                .toString();

                                        return ListTile(
                                          title: Text(
                                            name,
                                          ),
                                          subtitle: Text(path ?? ''),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              const Divider(),
                                    )),
                                  )
                                : _saveAsFileName != null
                                    ? ListTile(
                                        title: const Text('Save file'),
                                        subtitle: Text(_saveAsFileName!),
                                      )
                                    : const SizedBox(),
              ),
              const SizedBox(
                height: 40.0,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Movie Description',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the movie Description';
                  }

                  return null;
                },
                onSaved: (value) => _movieDescription = value!,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Download link',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the Download Link';
                  }

                  return null;
                },
                onSaved: (value) => _downloadlink = value!,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Youtube Trailer link',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the Youtube Trailer Link';
                  }

                  return null;
                },
                onSaved: (value) => _youtubeTrailerLink = value!,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Upload movie image',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the Youtube Trailer Link';
                  }

                  return null;
                },
                onSaved: (value) => _youtubeTrailerLink = value!,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Login'),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
