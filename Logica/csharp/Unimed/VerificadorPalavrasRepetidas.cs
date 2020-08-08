using System;
using System.Linq;

namespace Unimed
{
    public class VerificadorPalavrasRepetidas
    {
        public string Verifica(string palavra)
        {  
            char[] auxiliar = palavra.ToCharArray();
            string letrasRepetidas = null;

            for(int i =0; i < auxiliar.Length; i++){
                for(int j = 0; j < auxiliar.Length; j++){
                    if(auxiliar[i] == auxiliar[j] && j != i){
                        if(String.IsNullOrEmpty(letrasRepetidas)){
                            letrasRepetidas = auxiliar[j].ToString();
                        }else if (!letrasRepetidas.Contains(auxiliar[j].ToString())){
                            letrasRepetidas += "," + auxiliar[j];
                        }
                    }
                }
            }
            return String.IsNullOrEmpty(letrasRepetidas) ? palavra + ": none" : palavra + ": " + letrasRepetidas;
        }
    }
}