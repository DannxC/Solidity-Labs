// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;
  
//podemos importar do "Open Zeppelin" -> uma open source tool que nos permite usar um monte de contratos "pré montados"
//Nesse caso, basta ir no https://docs.openzeppelin.com/contracts/4.x/api/utils#SafeMath
//OBS: SafeMath nao é mais necessária a partir da versao 0.8.0, em que a solidity é construída em cima de um "overflow checking"
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";


//IMPORTANTEEEEE!!!!!!!!!!!!!!!!!!!!!!!!
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
/*
//Essa linha acima é equivalente a tudo o q está a seguir na "interface"
//Para obter a interface abaixo, basta fazer "rpm @chainlink/contracts" no navegador ou acessar diretamente esse repositorio do github:
//https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);
  function description() external view returns (string memory);
  function version() external view returns (uint256);

  // getRoundData and latestRoundData should both raise "No data present"
  // if they do not have data to report, instead of returning unset values
  // which could be misinterpreted as actual reported values.
  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
}
//Interfaces compile down to an ABI (Application Binary Interface)
//Teh ABI tells solidity and other programming languages how it can interact with another contract
*/



contract FundMe {
    using SafeMathChainlink for uint256;    //verificar overflow para os tipos uint256 ao longo do codigo...
                                            //significa: "usar" a library "SafeMathChainlink" no "tipo" neste contract em questao...
                                            //library é muito parecido com contract, pq sao de fato um "contract" que foi codado uma unica vez, e está num bloco de endereço fixo na blockchain... ele é reusado todo momento por diferentes pessoas como uma "library"

    mapping(address => uint256) public addressToAmountFunded;   //feito para trackear quem nos enviou dinheiro/nos financiou (qual endereço)
    address[] public funders;
    address public owner;  //variavel feita para guardar o endereço do criador do smart contract!

    //uma função que vc quer q seja usada apenas no momento de "deploy" do smart contract nós chamamos de "constructor", já que ela faz parte do momento de criação do smart contract!
    //o que quer q coloquemos na constructor, será ativada no momento de criação do smart contract!
    constructor() public {
        owner = msg.sender;//no caso, o msg.sender desse "contructor" sempre será aquele que fez o deploy do smart contract!
    }

    //payable é pq essa função pode ser usada para pagar coisas... quando chamamos uma função, ela tem um valor associado de gas (wei)...
    //nesse caso, porem, podemos escolher pagar uma taxa "x" de gas (wei) para utilizar essa function... isso significa o q?
    //Bom, quanto mais vc escolhe pagar para utilizar essa function, 
    function fund() public payable {
        uint256 minimumUSD = 50 * 10 ** 18;   //estamos trabalhando (no codigo) com weis;
        /*if(msg.value < minimumUSD) {
            //parar de executar a função
        } */        //podemos fazer esse if... ou entao fazemos de um jeito mt mais facil e pratico:
        require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more Eth");  //obs: nao precisa ter a partir do:   , "you need to spend more Eth"
                                                                                            //o codigo podia ser sem a mensagem de "erro": require(getConversionRate(msg.value) >= minimumUSD);

        addressToAmountFunded[msg.sender] += msg.value;     //obs: "msg.sender" é quem enviou (pagou) pelo "uso da function" e msg.value é quanto esse endereço pagou por essa call...
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);    //para pegar esse endereço, vá aqui: https://docs.chain.link/docs/ethereum-addresses/ ->
                                                                                                                //Rinkeby TestNet (neses caso... se for na mainnet vai ser um endereço diferente! Atenção!!!! 
                                                                                                                //Enfim, daí dps pega o endereço relacionado a ETH / USD
                                                                                                                //ESSA PRIMEIRA LINHA DIZ QUE NÓS TEMOS UM CONTRACT EM QUE AS FUNÇÕES DEFINIDAS LA NA INTERFACE ESTÃO LOCALIZADAS NESSE ENDEREÇO!!!!
        return priceFeed.version();     //podemos chamar a função "version" (que está na interface) pois o priceFeed está igualado a um contract que, a priori, possui todas as funções declaradas (que estao na interface) dentro dele!
    }

/*    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (uint80 roundId,        //essa sintaxe é o que a gnt usa para definir um "tuple". Com um "tuple", podemos definir varias variáveis dentro dele.
        int256 answer,          //obs: podemos fazer a atribuição a um tuple desde que o que está sendo atribuido tambem tem o formato identico ao tuple (note que a função usada é a da interface, e é la q esse tuple aparece!)
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound)
        = priceFeed.latestRoundData();    //Veja na Interface, que  essa function pode ter até 5 diferentes returns.
        return uint256(answer);     //forma de fazer uma mudança de tipo em solidity
    }
*/
    //A função acima pode ser escrita assim também:
    //no caso, utilizamos o "tuple" sem as variaveis q nao estao sendo utilizadas (o compilador prefere assim, alem de deixar mais clean o codigo)
    //Dessa forma, podemos atribuir um tuple a outro (que é o caso), em que os locais vazios são como "hey, tem uma variavel aqui mas nao estamos usando!)
    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 10 ** 10);     //AGORA ISSO VAI RETORNAR UM PREÇO COM 18 CASAS DECIMAIS, ISTO É, VAI DAR O VALOR CERTINHO EM DOLAR para WEI
    }

    //função para converter em dolar
    function getConversionRate(uint256 ethAmount) public view returns (uint256) {       //ethAmount é em wei, bem como o ethPrice
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;      //retorna tudo em wei...
    }

    //podemos mudar o comporteamento de uma função utilizando um "modifier"... veja como este funciona na função "withdraw"
    //lembrando q o modifier atua diretamente na declaração da function... ele vai fazer tudo antes do '_;'
    modifier onlyOwner {
        require(msg.sender == owner);
        _;  //isso é como um "continue rodando o codigo depois de conseguir fazer o require dar certo"
    }

    //obs:.transfer(x) é uma função q podemos chamar para qualquer endereço (no caso "msg.sender", quem chamou a função), que permite mandar x Eth de um endereço pra outro (no caso, do endereço "this" para o de quem "chamou a function")...
    function withdraw() payable onlyOwner public {
        //queremos que apenas o "dono do contract" seja capaz de utilizar essa função... pois ela é capaz de retirar TODO o dinheiro que foi depositado nela pelo "fund"... entao, não é qualquer um q deveria fazer isso!
        //podemos fazer: require msg.sender = onwer  .... mas como q faz pra chamar o endereço do dono?
        //se fizermos uma função "createowner" vai dar merda, pq se alguem chamar essa function ela vai se tornar o "owner"...
        //pra isso existe a primeira função do smart contract (normalmente fazemos como a primeira)! Ela serve pra atribuir o owner no instante em que o smart contract foi criado! (deployed)
        /*require(msg.sender == owner);*/ //ISSO ERA A SOLUÇÃO ANTES DE SUAR O MODIFIER... USANDO O MODIFIER NAO PRECISA DISSO! O MODIFIER ESTÁ LOGO ACIMA, BASTA VER ELE TAMBEM NA DECLARAÇÃO DA FUNCTION
        //usando o modifier, ele vai primeiro checar se o msg.sender DESSA FUNCTION é == owner e dps vai continuar rodando o codigo! é como fzer um request generico q dapra ser usado em diversas functions... util
        
        msg.sender.transfer(address(this).balance);     //address(this) refere-se ao endereço do contract que estamos trabalhando no momento, enquanto o ".balance" refere-se a quanto existe de dindin nesse endereço.
        
        for(uint256 funderIndex = 0; funderIndex < funders.lenght; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;       //com esse loop, estamos zerando o "fund" de todas as carteiras no "mapping"...
        }      //parece muito com C
        funders = new address[](0);        //precisamos tambem resetar o array de "funders" em si... fazemos isso igualando a um "novo" array de endereços, totalmente em branco!
    }
}