// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

//OBS: SimpleStorage nesse caso virou um tipo de "objeto" (variavel) possível de sercriado
import "./SimpleStorage.sol";   //SimpleStore está na mesma pasta do StorageFactory por isso usa "./". Alem disso,
                                //"import" serve para que os arquivos conversem entre si. No caso, esse consegue "ver"
                                //a existencia do que foi importado. (nao vale o contrario, pois no outro arquivo nao foi dado import.

contract StorageFactory is SimpleStorage {      //Todo o contract foi pensado sem o "is SimplesStorage"... apenas por add esta linha, todas as funções do "SimpleStorage.sol" e todas suas variáveis atuam também na StorageFactory.sol
                                                //Dessa forma, podemos usar diretamente as functions, definidas no outro contract, neste.
                                                //Btw... isso é chamado "inheritance" = Herança
    SimpleStorage[] public simpleStorageArray;

    //Essa função diz: estou criando um objeto do tipo "SimpleStorage", nomeando ele como simpleStorage e entao atribuindo a esse objeto
    //a uma "nova" SimpleStorage contract.
    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }


    //'sf' de StorageFactory
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        //Need Address or ABI
        SimpleStorage simpleStorage = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));  //método que nos permite trabalhar com o que há no outro contract!
        simpleStorage.store(_simpleStorageNumber);
    }

/*    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        SimpleStorage simpleStorage = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
        return simpleStorage.retrieve();
    }
*/
    //O método utilizado a seguir é mais direto e compacto, nao precisa ficar criando uma variavel SimpleStorage, atribuir o endereço dela e dps chamar a função do outro contract... pode fazer simplesmente isso!
    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        return SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).retrieve();
    }
}
