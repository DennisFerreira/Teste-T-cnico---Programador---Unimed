using System;
using System.Linq;

namespace Unimed.Implementacao
{
    public class Palindromo
    {
    
        public bool EhPalindromo(string palavra)
        {   
           char[] auxiliar = palavra.ToCharArray();

            string reverso = null;
            for (int i = auxiliar.Length - 1; i > 0 -1; i--){
                reverso += auxiliar[i].ToString();
            }
            if (string.Equals(palavra,reverso,StringComparison.CurrentCultureIgnoreCase)){
                return true;
            }else{
                    return false;
                 }
        }
    }
}