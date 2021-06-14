/**
 *  Tratador de evenvos para uma API Rest
 *
 *  @see
 * https://dev.to/simonplend/how-to-use-fetch-to-post-form-data-as-json-to-your-api-2pih
 */


 /**
  *  Função que envia os dados de um formulário usando um dos metodos:
  *  POST ou PUT.
  *  Se o metodo não for informado em uma entrada com nome `_metodo`,
  *  a função assume como default o metodo POST.
  *
  * @param {SubmitEvent} evento
  * @param {CallBack} callback - função a ser chamada quando a resposta chegar
  */

async function enviarDados(evento, callback) {
  /* O trecho a seguir inibe o comportamento default do browser
     de submeter imediatamente o formulário.                        */
  evento.preventDefault();

  /* Obtem o formulário ao qual o evento está associado.            */
  const formulario = evento.currentTarget;

  /* Obtem a URL da API a partir do atributo `action`.              */
  const url = formulario.action;


  try {
    /* Pega todos os campos do formulário e faz com que seus valores
       fiquem disponíveis via uma instância de `FormData`.

       @see https://developer.mozilla.org/en-US/docs/Web/API/FormData
    */
    const formData = new FormData(formulario);

    /* Envia os dados no formato JSON para a URL informada. */
    const dadosResposta = await enviaFormDataComoJson(url, formData);

    /* Assim que os dados do servidor chegarem, a função callback será
       chamada. */
    callback(dadosResposta);

  } catch (erro) {
    console.error(erro);
  }
}


/**
 *  Função auxiliar para postar dados no formato JSON usando fetch
 *
 * @param {string} url - URL para onde postar os dados
 * @param {FormData} formData- uma instância de FormData
 * @return {Object} - corpo da resposta devolvida pela URL
 */
async function enviaFormDataComoJson(url, formData) {
  /* Não se pode passar uma instância de `FormData` diretamente com
     `fetch`, pois isto faria que o corpo do pedido fosse automáticamente
     formatado como "multipart" e `Content-Type` como `multipart/form-data`.
     O que se deseja e evinar o corpo do pedido como JSON, assim esta
     função primeiro a converte em um objeto simples para depois converter
     esse objeto em uma string JSON.

     @see https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/POST
     @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/fromEntries
     @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/stringify
  */
  const formDataSimples = Object.fromEntries(formData.entries());

  let matodo = 'POST';

  if (typeof formDataSimples._metodo !== 'undefined') {
    metodo = formDataSimples._metodo;
    delete formDataSimples._metodo;
  };


  console.log('metodo = ', metodo);

  const stringJson = JSON.stringify(formDataSimples);

  console.log('json = ', stringJson);

  const opcoesFetch = {
    method: metodo,

    /* Estes cabeçalhos serão adicionados ao pedido e informarão
       à API que o corpo do pedido e um JSON e que aceita-se
       JSON como resposta.
     */
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json"
    },

    /* O Corpo do pedido e a string JSON criada acima.         */
    body: stringJson,
  };

  const resposta = await fetch(url, opcoesFetch);

  if (!resposta.ok) {
    const errorMessage = await resposta.text();
    throw new Error(errorMessage);
  }

  return resposta.json();
}


async function remover(url, callback){
  const opcoesFetch = {
    method: 'DELETE',

    /* Estes cabeçalhos serão adicionados ao pedido e informarão
       à API que o corpo do pedido e um JSON e que aceita-se
       JSON como resposta.
     */
    headers: {
      "Content-Type": "application/json"
    },

  };

  const resposta = await fetch(url, opcoesFetch);

  if (!resposta.ok) {
    const errorMessage = await resposta.text();
    throw new Error(errorMessage);
  }

  callback(resposta);
}
