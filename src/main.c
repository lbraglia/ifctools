#include <stdio.h>
#include "ifctools.h"
#include "reg_guess_fc_worker.h"

int main(void){

    char fc[REG_FC_LEN + 1] = {'\0'};

    printf("%s\n",
	   reg_guess_fc_worker("ROSSI",
			       "MARIO",
			       1980,
			       1,
			       1,
			       0,
			       "H223",
			       fc)
	);
    
    return 0;

}
