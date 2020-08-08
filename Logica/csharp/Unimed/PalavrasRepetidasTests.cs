using Xunit;

namespace Unimed
{
    public class PalavrasRepetidasTests
    {
        [Theory]
        [InlineData("bola", "bola: none")]
        [InlineData("abacate", "abacate: a")]
        [InlineData("ovo", "ovo: o")]
        [InlineData("paralelepipedo", "paralelepipedo: p,a,l,e")]
        [InlineData("kkkkkkkkkkkk", "kkkkkkkkkkkk: k")]
        public void PalavraRepetidaTest(string palavra, string esperado){
            
            var verificador = new VerificadorPalavrasRepetidas();
            var resultado = verificador.Verifica(palavra);
            Assert.Equal(esperado, resultado);
        }
    }
}
