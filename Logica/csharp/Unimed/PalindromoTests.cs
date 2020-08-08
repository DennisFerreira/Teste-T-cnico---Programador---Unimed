using System;
using Unimed.Implementacao;
using Xunit;

namespace Unimed
{
    public class PalindromoTests
    {
        [Theory]
        [InlineData("ovo")]
        [InlineData("OvO")]
        [InlineData("aba")]
        [InlineData("radar")]
        public void EhPalindromo(string palavra)
        {
            var palindromo = new Palindromo();
            Assert.True(palindromo.EhPalindromo(palavra));
        }

        [Theory]
        [InlineData("cabelo")]
        [InlineData("azeite")]
        [InlineData("azul")]
        [InlineData("vanderlei")]
        [InlineData("974464")]
        [InlineData("___9")]
        public void NaoEhPalindromoTests(string palavra)
        {
            var palindromo = new Palindromo();
            Assert.False(palindromo.EhPalindromo(palavra));
        }
    }
}
