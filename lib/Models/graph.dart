import 'package:flutter/cupertino.dart';

class Graph {
  List<SpecialVertex> vertices = [];
  var adjacencyList = new Map<SpecialVertex, List<Edge>>();
  List<Edge> allEdges = [];

  void addEdge(SpecialVertex first, SpecialVertex second, double weight) {
    Edge temp = new Edge(node1: first, node2: second, weight: weight);
    adjacencyList[first]?.add(temp);
    adjacencyList[second]?.add(temp);
    allEdges.add(temp);
  }

  void addVertex(SpecialVertex v) {
    vertices.add(v);
    adjacencyList[v] = [];
  }

  List<Edge> adjacentTo(SpecialVertex v) {
    List<Edge>? adj = adjacencyList[v];
    for (Edge e in adj!) {
      if (e.node1 != v) {
        e.node2 = e.node1;
        e.node1 = v;
      }
    }
    return adj;
  }
}

class Edge {
  SpecialVertex node1;
  double weight;
  SpecialVertex node2;

  Edge({required this.node2, required this.weight, required this.node1});
}

class Vertex {
  int label;

  Vertex({required this.label});
}

class SpecialVertex extends Vertex {
  int label;
  late SpecialVertex par;
  late Edge track;
  double key = double.maxFinite;
  SpecialVertex({required this.label}) : super(label: label);

  @override
  int get hashCode => label;

  @override
  bool operator ==(other) {
    if (other is SpecialVertex) {
      return other.label == this.label;
    }
    return false;
  }
}

int hashedInt(int a, int b) {
  return (0.5 * (a + b + 1) * (a + b) + b).toInt();
}
