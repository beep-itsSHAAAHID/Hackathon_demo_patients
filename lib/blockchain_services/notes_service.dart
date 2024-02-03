import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:blockchain_demo/note.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;

class NotesServices extends ChangeNotifier {
  List<Note> notes = [];
  final String _rpcUrl = 'http://127.0.0.1:7545';
  final String _wsUrl = 'ws://127.0.0.1:7545';
  final String _privateKey =
      '0x8fd748b58b4fc16123d518ba6f77f7c40e3bef4f4a04162e0157eaa38b560b4e';

  late Web3Client _web3client;

  NotesServices() {
    init();
  }

  Future<void> init() async {
    print('Initializing NotesServices...');
    _web3client = Web3Client(
        _rpcUrl,
        http.Client(),
        socketConnector: () {
          return IOWebSocketChannel.connect(_wsUrl).cast<String>();
        });
    print('WebSocket connected successfully.');

    await getNotesABI();
    print('Notes ABI fetched.');

    await getNotesCredentials();
    print('Notes credentials loaded.');

    await getNotesDeployedContract();
    print('Notes deployed contract initialized.');

    await getDocumentsABI();
    print('Documents ABI fetched.');

    await getDocumentsCredentials();
    print('Documents credentials loaded.');

    await getDocumentsDeployedContract();
    print('Documents deployed contract initialized.');

    print('NotesServices initialized successfully.');
  }


  late ContractAbi _notesAbiCode;
  late EthereumAddress _notesContractAddress;
  late DeployedContract _notesDeployedContract;
  late ContractFunction _createNote;
  late ContractFunction _deleteNote;
  late ContractFunction _getNotes;
  late ContractFunction _noteCount;

  Future<void> getNotesABI() async {
    String abiFile = await rootBundle.loadString('build/contracts/NotesContract.json');
    var jsonABI = jsonDecode(abiFile);
    _notesAbiCode = ContractAbi.fromJson(jsonEncode(jsonABI['abi']), 'NotesContract');
    _notesContractAddress = EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
  }

  late EthPrivateKey _notesCreds;
  Future<void> getNotesCredentials() async {
    _notesCreds = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> getNotesDeployedContract() async {
    _notesDeployedContract = DeployedContract(_notesAbiCode, _notesContractAddress);
    _createNote = _notesDeployedContract.function('createNote');
    _deleteNote = _notesDeployedContract.function('deleteNote');
    _getNotes = _notesDeployedContract.function('notes');
    _noteCount = _notesDeployedContract.function('noteCount');
    await fetchNotes();
  }

  Future<void> fetchNotes() async {
    List totalTaskList = await _web3client.call(
      contract: _notesDeployedContract,
      function: _noteCount,
      params: [],
    );

    int totalTaskLen = totalTaskList[0].toInt();
    notes.clear();
    for (var i = 0; i < totalTaskLen; i++) {
      var temp = await _web3client.call(
        contract: _notesDeployedContract,
        function: _getNotes,
        params: [BigInt.from(i)],
      );
      if (temp[1] != "") {
        notes.add(
          Note(
            id: (temp[0] as BigInt).toInt(),
            title: temp[1],
            description: temp[2],
          ),
        );
      }
    }

    notifyListeners();
  }

  Future<void> addNote(String title, String description) async {
    await _web3client.sendTransaction(
      _notesCreds,
      Transaction.callContract(
        contract: _notesDeployedContract,
        function: _createNote,
        parameters: [title, description],
      ),
    );

    notifyListeners();
    fetchNotes();
  }

  // Functions for DocumentsContract

  late ContractAbi _documentsAbiCode;
  late EthereumAddress _documentsContractAddress;
  late DeployedContract _documentsDeployedContract;
  late ContractFunction _addDocument;
  late ContractFunction _getDocuments;
  late ContractFunction _deleteDocument;

  Future<void> getDocumentsABI() async {
    String abiFile = await rootBundle.loadString('build/contracts/DocumentsContract.json');
    var jsonABI = jsonDecode(abiFile);
    _documentsAbiCode = ContractAbi.fromJson(jsonEncode(jsonABI['abi']), 'DocumentsContract');
    _documentsContractAddress = EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
  }

  late EthPrivateKey _documentsCreds;
  Future<void> getDocumentsCredentials() async {
    _documentsCreds = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> getDocumentsDeployedContract() async {
    _documentsDeployedContract = DeployedContract(_documentsAbiCode, _documentsContractAddress);
    _addDocument = _documentsDeployedContract.function('addDocument');
    _getDocuments = _documentsDeployedContract.function('getDocuments');
    _deleteDocument = _documentsDeployedContract.function('deleteDocument');
  }

  Future<void> addDocumentToNote( String documentType, Uint8List documentHash) async {
    await _web3client.sendTransaction(
      _documentsCreds,
      Transaction.callContract(
        contract: _documentsDeployedContract,
        function: _addDocument,
        parameters: [ documentType, documentHash],
      ),
    );

    notifyListeners();
  }

  Future<List<Document>> getDocumentsForNote(int noteId) async {
    List<dynamic> documentsList = await _web3client.call(
      contract: _documentsDeployedContract,
      function: _getDocuments,
      params: [BigInt.from(noteId)],
    );

    List<Document> documents = [];
    for (var document in documentsList) {
      documents.add(
        Document(
          id: document[0].toInt(),
          type: document[1],
          hash: document[2],
        ),
      );
    }

    return documents;
  }

  Future<void> deleteDocument(int documentId) async {
    await _web3client.sendTransaction(
      _documentsCreds,
      Transaction.callContract(
        contract: _documentsDeployedContract,
        function: _deleteDocument,
        parameters: [documentId],
      ),
    );

    notifyListeners();
  }
}

class Document {
  final int id;
  final String type;
  final Uint8List hash;

  Document({required this.id, required this.type, required this.hash});
}
