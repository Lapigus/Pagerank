ranks = load '$r' as (id: int, url: chararray, rank: int);
edges = load '$ed' as (id1: int, id2: int);

-- get contributors and nodes they contribute to
contributor = cogroup ranks by id, edges by id1;

-- get number of node they contribute to for each of them
number_of_contrib = foreach contributor generate group, flatten(ranks.rank), COUNT(edges.id2) as cnt;

joined = join edges by id1, number_of_contrib by group;

contributions = foreach joined generate id1, id2, (float)rank/cnt as contribs;

neighbors = cogroup contributions by id2, ranks by id; 

new_ranks = foreach neighbors generate group, flatten(ranks.url), 0.15 + 0.85 * SUM(contributions.contribs); 

store new_ranks into '$out';
