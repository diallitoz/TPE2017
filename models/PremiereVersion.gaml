/**
 *  PremiereVersion
 *  Author: Azise
 *  Description: Premiere version de l'implementation GAMA du modele mathematique sur le declenchement de la peur face un danger
 */ model
PremiereVersion /* Insert your model definition here */
global torus: false
{ //defini la taille de l environnement
 int width_and_height_of_environment <- 1000;
	//geometry shape <- rectangle(width_and_height_of_environment # m, width_and_height_of_environment # m);
	int nbreArbre;
	int nbreFeu <- 10;
	int dureeCremationArbre <- 300; //Temps nécessaire pourqu'un arbre se consomme totalement
 int dureeCremationBatiment <- 500; //Temps nécessaire pourqu'un batiment se consomme totalement
	float speed; // Ici on initialise les agents
 //Initailisation globale
 init
	{ 
	
	// Creation de nbreArbre arbres sains au départ
 create arbre number: nbreArbre
		{
		} 
		
		// Creation de nbreArbreFeu feu au départ
 create feu number: nbreFeu
		{
		}
		
 create abri number: 1 
		{
			 location <-point(1, 1 );
		}
		
create abri number: 1
		{
			location <-point(1, 999);
		}
		
create abri number: 1 
		{
			location <-point(999, 1 );
		}
		
create abri number: 1
		{
			location <-point(999, 999);
		}
		
create batiment number: 10
		{
		}
create habitantCraintifNonExp number: 10
		{
		}
create habitantCraintifExp number: 10
		{
		}		
create habitantOptiNonExp number: 10
		{
		}
create habitantOptiExp number: 10
		{
		}			
	} 
	
	
	
	// Tous les agents succeptibles de se deplacer ou meme statiques heritent de ce specie
 species position
	{
		int x;
		int y;
	} 
	
	//Habitant fictif
 species habitantFictif parent: position skills: [moving]
	{
		point target; // la cible du pompier à un instant donné
		rgb color ;
		const size type : int init: 2;
		int rayonPerception <- 50;
		float fearEnv <- 0.0;
		float dangerFam <- 0.0;
		float percepSubjectivity <- 0.0;

		init
		{
		
			x <- rnd(width_and_height_of_environment - 2 * size) + size;
			y <- rnd(width_and_height_of_environment - 2 * size) + size;
			location <- point(x, y);
		}

		aspect base
		{
			draw circle(size);
		}


	}
	
	species habitantCraintifNonExp parent: habitantFictif
	{
		
		
		
		init
		{
		
			x <- rnd(width_and_height_of_environment - 2 * size) + size;
			y <- rnd(width_and_height_of_environment - 2 * size) + size;
			location <- point(x, y);
			fearEnv <- 0.0;
		 	dangerFam  <- 0.1;
		 	percepSubjectivity <- 3.0;
		 	color <- rgb('orange');
			
		}
		
		reflex fearEnv
		{
			
		}
		
		
	}
	
	species habitantCraintifExp parent: habitantFictif
	{
		
		
		init
		{
		
			x <- rnd(width_and_height_of_environment - 2 * size) + size;
			y <- rnd(width_and_height_of_environment - 2 * size) + size;
			location <- point(x, y);
			fearEnv <- 0.0;
		 	dangerFam  <- 0.8;
		 	percepSubjectivity <- 3.0;
		 	color <- rgb('moccasin');
			
		}
		
		
	}
	
	species habitantOptiNonExp parent: habitantFictif
	{
		
		
		init
		{
		
			x <- rnd(width_and_height_of_environment - 2 * size) + size;
			y <- rnd(width_and_height_of_environment - 2 * size) + size;
			location <- point(x, y);
			fearEnv <- 0.0;
		 	dangerFam  <- 0.8;
		 	percepSubjectivity <- 3.0;
		 	color <- rgb('yellow');
			
		}
		
		
	}
	
	species habitantOptiExp parent: habitantFictif
	{
		
		
		init
		{
		
			x <- rnd(width_and_height_of_environment - 2 * size) + size;
			y <- rnd(width_and_height_of_environment - 2 * size) + size;
			location <- point(x, y);
			fearEnv <- 0.0;
		 	dangerFam  <- 0.8;
		 	percepSubjectivity <- 3.0;
		 	color <- rgb('brown');
			
		}
		
		
	}
	
	
	species habitantObjectifNonExp parent: habitantFictif
	{
		
		
		init
		{
		
			x <- rnd(width_and_height_of_environment - 2 * size) + size;
			y <- rnd(width_and_height_of_environment - 2 * size) + size;
			location <- point(x, y);
			fearEnv <- 0.0;
		 	dangerFam  <- 0.8;
		 	percepSubjectivity <- 3.0;
		 	color <- rgb('violet');
			
		}
		
		
	}
	
	species habitantObjectifExp parent: habitantFictif
	{
		
		
		init
		{
		
			x <- rnd(width_and_height_of_environment - 2 * size) + size;
			y <- rnd(width_and_height_of_environment - 2 * size) + size;
			location <- point(x, y);
			fearEnv <- 0.0;
		 	dangerFam  <- 0.8;
		 	percepSubjectivity <- 3.0;
		 	color <- rgb('indigo');
			
		}
		
		
	}

	species feu parent: position 
	{
		rgb color;
		float rangeFeu <- 3.0;
		int size <- 1 + rnd(2);
		int temp <- 0;
		int numeroOrdre <- 0;
		init
		{
			x <- rnd(width_and_height_of_environment - 2 * size) + size;
			y <- rnd(width_and_height_of_environment - 2 * size) + size;
			location <- point(x, y);
			color <- rgb(225 + rnd(30), 0, 0);
		}

		reflex propager
		{
			ask arbre at_distance (rangeFeu)
			{
				if (flip(0.5))
				{
					create feu number: 1 with: (location: { self.location.x, self.location.y });
					//do die;
					
				}

			}

		}


		reflex bruler when: temp <= dureeCremationArbre
		{
			temp <- temp + 1;
			color <- rgb(255, rnd(255), 0);
		}

		reflex mourir when: temp = dureeCremationArbre
		{
			create arbreMort number: 1 with: (location: { self.location.x, self.location.y });
			do die;
		} 
		
		
 		aspect base
		{
			draw circle(size);
		}
	}

} 

// ceci est un arbre sain qui est vert et sa taille varie entre 1 et 3 cases
 species arbre parent: position control: fsm
{
	rgb color;
	int size <- 1 + rnd(1);
	vegetation_cell myCell <- one_of (vegetation_cell) ;
	init
	{
		color <- rgb('forestgreen');
		x <- rnd(width_and_height_of_environment - 2 * size) + size;
		y <- rnd(width_and_height_of_environment - 2 * size) + size;
		location <- myCell.location;
		//location <- point(x, y);
	}

	aspect base
	{
		draw circle(size);
	}

} 


species batiment parent: position control: fsm
{
	rgb color;
	int size <- 2 + rnd(3);
	init
	{
		color <- rgb('gray');
		x <- rnd(width_and_height_of_environment - 2 * size) + size;
		y <- rnd(width_and_height_of_environment - 2 * size) + size;
		location <- point(x, y);
	}

	aspect base
	{
		draw square(size);
	}

} 


species abri parent: position control: fsm
{
	rgb color;
	int size <- 5 ;
	init
	{
		color <- rgb('blue');
	}

	aspect base
	{
		draw square(size);
	}

} 


//arbre mort il n'a pas grand chose comme propriété juste sa taille et sa couleur qui change et devient cendre
 species arbreMort parent: position
{
	rgb color <- rgb('gainsboro');
	int size <- 1;
	aspect base
	{
		draw circle(size);
	}

}

species batimentDetruit parent: position control: fsm
{
	rgb color <- rgb('gainsboro');
	int size <- 1;
	
	aspect base
	{
		draw square(size);
	}

} 


grid vegetation_cell width: 50 height: 50 neighbours: 4 {
	float maxFood <- 1.0 ;
	float foodProd <- (rnd(1000) / 1000) * 0.01 ;
	float food <- (rnd(1000) / 1000) max: maxFood update: food + foodProd ;
	rgb color <- rgb(int(255 * (1 - food)), 255, int(255 * (1 - food))) update: rgb(int(255 * (1 - food)), 255, int(255 *(1 - food))) ;
}



experiment declenchement type: gui
{
	parameter "nombre d'arbres" var: nbreArbre init: 100 category : "Environment";
	parameter "Width and height of environment" var: width_and_height_of_environment category : "Environment" min : 100 max : 2000;
	output
	{
		display main_display
		{
			grid vegetation_cell lines: #black ;
			species arbre aspect: base;
			//species feu aspect: base;
			//species batiment aspect: base;
			//species abri aspect: base;
			//species habitantCraintifExp aspect: base;
			//species habitantCraintifNonExp aspect: base;
			//species habitantOptiNonExp aspect: base;
			//species habitantOptiExp aspect: base;
			//species habitantObjectifExp aspect: base;
			//species habitantObjectifNonExp aspect: base;
			//species arbreMort aspect: base;
			//species batimentDetruit aspect: base;
		}

	}

} 
