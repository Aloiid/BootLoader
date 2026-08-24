//petit kernel en C 


void kernel_main (void) {

//volatile tells the compiler not to optimize anything that has to do with the volatile variable.
//source : https://stackoverflow.com/questions/246127/why-is-volatile-needed-in-c
//le short contient 2 octets donc il aurait fallu trouver une autre manière de rmleplir le tableau. On va donc prendre le char qui fait un seul octets
volatile char * vga = (volatile char *) 0XB8000;
const char couleur = 0x2F;
const char * msg = "Howdy depuis le KERNEL YEAH!!!!";
//int msgTaille = strlen(msg) - 1; 
int i = 0; 
int j = 0; 
//on rentre dnas la boucle pour afficher le message 
 
while(msg[i] != 0){

	vga[j] = msg[i]; 
	vga[j+1] = couleur; 
	i++;
	j = j + 2; 

}
//on fait une boucle à l'infinie pour éviter que le noyau ne s'arrete.

while (1) {

//rien ici 

}
	
}
