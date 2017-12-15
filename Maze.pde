class Maze {
  int h;
  int w;
  
  Set<Edge> graph = new HashSet<Edge>();
  Node[][] nodes;
  
  public Boolean[][] convertedGraph;
  
  
  Maze(int h, int w)
  {
    this.h = h;
    this.w = w;

    CreateNodes();
    AddEdges();
    
    graph = MST(graph);

    convertedGraph = ConvertToBoolean(graph);
  }
  
  
  void CreateNodes() {
    int w = (this.w % 2 == 0) ? this.w + 1 : this.w;
    int h = (this.h % 2 == 0) ? this.h + 1 : this.h;
    int nodesI = (h + 1) / 2;
    int nodesJ = (w + 1) / 2;

    nodes = new Node[nodesI][nodesJ];

    for (int k = 0, i = 0; i < nodesI; i++) {
      for (int z = 0, j = 0; j < nodesJ; j++) {
        nodes[i][j] = new Node(k, z);
        z += 2;
      }
      
      k += 2; 
    }
  }
  
  
  void AddEdges() {
    for (int i = 0; i < nodes[0].length; i++) {
      for (int j = 0; j < nodes[1].length; j++) {
        if (i < nodes[0].length - 1) {
          Edge edge = new Edge(nodes[i][j], nodes[i + 1][j]);

          graph.add(edge);
         }

        if (j < nodes[1].length - 1) {
          Edge edge = new Edge(nodes[i][j], nodes[i][j + 1]);

          graph.add(edge);
        }
      }
    }
  }
  
  
  Set<Edge> MST(Set<Edge> edges) {
    Set<Edge> edgesInMST = new HashSet<Edge>();
    Set<Edge> possibleEdges = new TreeSet<Edge>();
    Set<Node> nodesInMST = new HashSet<Node>();
    
    nodesInMST.add(nodes[random.nextInt(nodes[0].length)][random.nextInt(nodes[1].length)]);
    
    while (edgesInMST.size() != nodes[0].length * nodes[1].length - 1) {
      possibleEdges = FindEdges(nodesInMST);
      Set<Edge> possibleEdgesToMST = new HashSet<Edge>();
      
      for (Edge edge: possibleEdges) {
        int connections = 0;
        
        for (Node node: nodesInMST) {
          if (edge.nodeA == node || edge.nodeB == node) connections++;
        }
        
        if(connections != 1) continue;
        
        possibleEdgesToMST.add(edge);
      }
      
      if(possibleEdgesToMST.size() > 0) {
        Edge edgeToMST = GetEdgeFromSet(possibleEdgesToMST, random.nextInt(possibleEdgesToMST.size()));
        
        nodesInMST.add(edgeToMST.nodeA);
        edgesInMST.add(edgeToMST);
        nodesInMST.add(edgeToMST.nodeB);
      }
    }
    
    return edgesInMST;
  }
  
  
  Set<Edge> FindEdges(Set<Node> nodes) {
    HashSet<Edge> edges = new HashSet<Edge>();

    for (Node node: nodes) {
      for (Edge edge: this.graph) {
        if (edge.nodeA == node || edge.nodeB == node) {
          edges.add(edge);
        }
      }
    }
    
    return edges;
  }
  
  Edge GetEdgeFromSet(Set<Edge> edges, int index) {
    int i = 0;
    for (Edge edge: edges) {
      if(i == index) return edge;
      i++;
    }
    
    return null;
  }
  
  Boolean[][] ConvertToBoolean(Set<Edge> edges) {
    int h = (this.h % 2 == 0) ? this.h + 1 : this.h;
    int w = (this.w % 2 == 0) ? this.w + 1 : this.w;
    
    int k = 0;
    
    convertedGraph = new Boolean[h][w];
    for (Boolean[] row: convertedGraph) {
      Arrays.fill(convertedGraph[k], false);
      k++;
    }
    
    for (Edge edge: graph)
    {
      convertedGraph[edge.nodeA.i][edge.nodeA.j] = true;
      convertedGraph[edge.i][edge.j] = true;
      convertedGraph[edge.nodeB.i][edge.nodeB.j] = true;
    }

    return convertedGraph;
  }
  
  class Node {
    public int i;
    public int j;
    
    
    public Node(int i, int j)
    {
      this.i = i;
      this.j = j;
    }
  }
  
  
  class Edge {
    public Node nodeA;
    public Node nodeB;
    
    public int i;
    public int j;
    
    
    public Edge(Node nodeA, Node nodeB) {
      this.nodeA = nodeA;
      this.nodeB = nodeB;
      
      GetCoords();
    }
    
    
    void GetCoords() {
      this.i = nodeA.i + (nodeB.i - nodeA.i) / 2;
      this.j = nodeA.j + (nodeB.j - nodeA.j) / 2;
    }
  }
}