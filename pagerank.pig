vertex = load 'hollins.dat/hollins-vertices' using PigStorage(' ') as (id: int, url: chararray);
edges = load 'hollins.dat/hollins-edges' using PigStorage(' ') as (id1: int, id2: int);
ranks = load 'hollins.dat/r' as (id: int, rank: int);

-- get contributors and nodes they contribute to
contributor = cogroup vertex by id, edges by id1;

-- get number of node they contribute to for each of them
number_of_contrib = foreach contributor generate group, COUNT(edges.id2) as cnt;

joined = join edges by id1, ranks by id, number_of_contrib by group;

contributions = foreach joined generate id1, id2, (float)rank/cnt as contribs;

-- group by url and get theirs contributors with theirs contributions
cogrouped = cogroup vertex by id, contributions by id2;

neighbors = foreach cogrouped generate group, flatten(vertex.url), contributions.(id1, contribs) as c;

new_ranks = foreach neighbors generate group, 0.15 + 0.85 * SUM(c.contribs);

fs -rmr myoutput;
store new_ranks into 'myoutput';

dump new_ranks;
