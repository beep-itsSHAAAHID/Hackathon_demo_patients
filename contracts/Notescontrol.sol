// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract DocumentsContract {
    uint256 public documentCount = 0;

    struct Document {
        uint256 id;
        string documentType;
        string documentHash; // You can store IPFS or any hash of the document
    }

    mapping(uint256 => Document) public documents;

    event DocumentAdded(uint256 documentId, string documentType, string documentHash);

    function addDocument(string memory _documentType, string memory _documentHash) public {
        documents[documentCount] = Document(documentCount, _documentType, _documentHash);
        emit DocumentAdded(documentCount, _documentType, _documentHash);
        documentCount++;
    }
}
