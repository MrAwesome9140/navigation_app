import 'package:collection/collection.dart';
import '../Models/graph.dart';

class GraphOperations {
  List<Edge> mst(Graph g) {
    List<bool> done = List.filled(g.vertices.length, false, growable: false);
    List<SpecialVertex> verts = g.vertices;
    done.fillRange(0, done.length, false);
    verts[0].key = 0;
    PriorityQueue<SpecialVertex> queue = new PriorityQueue<SpecialVertex>((a, b) {
      return a.key.compareTo(b.key);
    })
      ..addAll(verts);
    while (queue.isNotEmpty) {
      SpecialVertex temp = queue.removeFirst();
      done[temp.label] = true;
      for (Edge e in g.adjacentTo(temp)) {
        SpecialVertex to = e.node2;
        if (!done[to.label] && e.weight < to.key) {
          verts[to.label].par = temp;
          verts[to.label].key = e.weight;
          verts[to.label].track = e;
        }
      }
    }
    List<Edge> edges = [];
    for (int i = 1; i < verts.length; i++) {
      edges.add(verts[i].track);
    }
    return edges;
  }

  List<SpecialVertex> optimumTour(Graph g) {
    var current = g.vertices[0];
    Map<Edge, bool> searched = Map<Edge, bool>();
    g.allEdges.forEach((e) => searched[e] = false);
    List<SpecialVertex> tour = [];
    List<Edge> path = [];
    tour.add(current);
    Edge adj = g.adjacentTo(current)[0];
    searched[adj] = true;
    path.add(adj);
    current = adj.node2;
    while (current != g.vertices[0]) {
      tour.add(current);
      List<Edge> adjacent = g.adjacentTo(current);
      for (Edge e in adjacent) {
        var temp = searched[e];
        if (temp != null && !temp) {
          path.add(e);
          current = e.node2;
          searched[e] = true;
          break;
        }
      }
    }
    for (int i = 0; i < tour.length; i++) {
      SpecialVertex v = tour[i];
      List<Edge> adjacents = g.adjacentTo(v);
      for (int k = 0; k < adjacents.length; k++) {
        var temp = searched[adjacents[k]];
        if (temp != null && !temp) {
          current = v;
          List<SpecialVertex> route = [];
          List<Edge> edges = [];
          eulersTour(current, searched, route, edges, g);
          tour = tour.sublist(0, i) + route + tour.sublist(i, tour.length);
          path = path.sublist(0, i) + edges + path.sublist(i, path.length);
        }
      }
    }
    List<SpecialVertex> hamilTour = [];
    tour.forEach((element) {
      if (!hamilTour.contains(element)) hamilTour.add(element);
    });
    return hamilTour;
  }

  void eulersTour(SpecialVertex initial, Map<Edge, bool> searched, List<SpecialVertex> tour, List<Edge> path, Graph g) {
    SpecialVertex current = initial;
    tour.add(current);
    List<Edge> adjacent = g.adjacentTo(current);
    for (Edge e in adjacent) {
      var temp = searched[e];
      if (temp != null && !temp) {
        path.add(e);
        current = e.node2;
        searched[e] = true;
        break;
      }
    }
    while (current != initial) {
      tour.add(current);
      List<Edge> adjacent = g.adjacentTo(current);
      for (Edge e in adjacent) {
        var temp = searched[e];
        if (temp != null && !temp) {
          path.add(e);
          current = e.node2;
          searched[e] = true;
          break;
        }
      }
    }
  }

  Graph oddDegreeVertGraph(List<Edge> edges, Graph g) {
    List<int> degrees = new List<int>.filled(g.vertices.length, 0, growable: false);
    edges.forEach((element) {
      degrees[element.node1.label]++;
      degrees[element.node2.label]++;
    });
    Graph oddies = new Graph();
    for (int i = 0; i < degrees.length; i++) {
      if (degrees[i] % 2 != 0) oddies.addVertex(g.vertices[i]);
    }
    oddies.vertices.forEach((v) {
      g.adjacentTo(v).forEach((e) {
        if (oddies.vertices.contains(e.node2)) oddies.addEdge(v, e.node2, e.weight);
      });
    });
    return oddies;
  }

  Graph uniteMinSpanAndPerMatch(Graph g, List<Edge> mst, List<Edge> perMatch) {
    Graph multiGraph = new Graph();
    g.vertices.forEach((v) => multiGraph.addVertex(v));
    mst.forEach((e) => multiGraph.addEdge(e.node1, e.node2, e.weight));
    perMatch.forEach((e) => multiGraph.addEdge(e.node1, e.node2, e.weight));
    return multiGraph;
  }

  List<Edge> minWeightPerfectMatch(Graph oddies) {
    List<Edge> match = [];
    List<bool> matched = new List<bool>.filled(oddies.vertices.last.label + 1, false);
    oddies.allEdges.sort((a, b) {
      return a.weight.compareTo(b.weight);
    });
    oddies.allEdges.forEach((e) {
      if (!(matched[e.node1.label] || matched[e.node2.label])) {
        match.add(e);
        matched[e.node1.label] = true;
        matched[e.node2.label] = true;
      }
    });
    return match;
  }
}
