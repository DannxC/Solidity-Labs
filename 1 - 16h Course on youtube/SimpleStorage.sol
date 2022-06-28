// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

contract SimpleStorage {
    uint256 favoriteNumber;  //'u' de unsigned (positivo) e 256 de 256bits (mais preciso)
                                    //inicializa em 0 por padrao...
/*  bool favoriteBool = true;   //lógica
    string favoriteString = "String";   //maneira de fazer string em solidity
    int256 favoriteIn = -5; //qualquer inteiro nesse caso
    address favoriteAddress = 0xFc8706d39Ca7af0441cc8f3C10242B5571A3171E;   //Endereço de uma carteira na blockchain (Ethereum)
    bytes32 favoriteBytes = "cat";  //bytes'x' significa q há x bytes nessa variavel...  vai de 1 até 32...
*/   
    bool favoriteBool;

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    //People public person = People({favoriteNumber: 2, name: "Patrick"});
    People[] public people;     //se deixar []. ele cria um array com tamanho variavel! Se fizer [x], cria um array com tamanho 5 fixo
    mapping(string => uint256) public nameToFavoriteNumber;     //forma rapida de procurar por um "uint256" conhecendo um "string". Por ex, eu sei o nome "Becca" mas nao sei
                                                                //seu numero favorito... daí eu uso isso e coloco Becca (uma string) e ele retorna o "numero favorito dela"(uint256) associado.

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    //view: significa que queremos apenas ler algum estado da blockchain. Variaveis globais tambem tem view functions
    //pure: fazem algum tipo de matematica
    //note que ambos ficam azuis no "Deployed Contracts", ou seja, não fazem alterações na Blockchain
    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }

    //quando usamos parametros que sao "strings", precisamos definir se ela vai ser armazenada na "memory" (apenas durante a execução da função)
    //ou se será na "storage" (que persiste mesmo depois de terminar o uso da function em questão) -> imagino q seja parecido com "static" em C.
    //Isso ocorre pois a string é um tipo especial de Array... e precisa fazer isso tudo para qualquer tipo de Array!
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));   //é equivalente escrever isso tbm: people.push(People({favoriteNumber: _favoriteNumber, name: _name}))
        nameToFavoriteNumber[_name] = _favoriteNumber;  //Dessa forma, o _name e o _favoriteNumber que forem inseridos na function vao, primeiro serem executados pelo people.push e serem
                                                        //adicionados ao array "people". Depois, vai ser adicionado na variavel do tipo mapping o _name => _favoriteNumber para ser facil de achar a correlação entre eles no futuro!                                                        
    }
}