#ifndef __RASTER_ORDER_LSH__
#define __RASTER_ORDER_LSH__

class RasterOrderLSH 
{
	public: 
		// A => sparse matrix input
		// nodes => nodes corresponding to sparse matrix
		// dim => dimension of ordering (if < dim of problem this projects nodes into lower cell overlay)
		// ndivs => number of subdivisions in overlay grid (equiv to sub divs of AABB)
		RasterOrderLSH ( ublas::sparse_matrix * A, ublas::vector< NodeType > & nodes, int dim , int ndivs ) {

			// Construct AABB (get min and max of each dim)

			// hash nodes into cells (Original hash value)
			for (int i = 0; i < N; i++) { 

			}

			// Sort nodes given hash index


			// output



		} 



	protected: 

	private: 

}



#endif 
