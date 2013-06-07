class Transformation < ActiveRecord::Base
  def source_metamodel
<<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<ecore:EPackage xmi:version="2.0"
    xmlns:xmi="http://www.omg.org/XMI" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:ecore="http://www.eclipse.org/emf/2002/Ecore" name="Tree"
    nsURI="Tree" nsPrefix="Tree">
  <eClassifiers xsi:type="ecore:EClass" name="Tree">
    <eStructuralFeatures xsi:type="ecore:EReference" name="children" upperBound="-1"
        eType="#//Tree" containment="true" eOpposite="#//Tree/parent"/>
    <eStructuralFeatures xsi:type="ecore:EReference" name="parent" eType="#//Tree"
        eOpposite="#//Tree/children"/>
    <eStructuralFeatures xsi:type="ecore:EAttribute" name="label" eType="ecore:EDataType http://www.eclipse.org/emf/2002/Ecore#//EString"/>
  </eClassifiers>
</ecore:EPackage>
EOS
  end
  
  def target_metamodel
<<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<ecore:EPackage xmi:version="2.0"
    xmlns:xmi="http://www.omg.org/XMI" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:ecore="http://www.eclipse.org/emf/2002/Ecore" name="Graph"
    nsURI="Graph" nsPrefix="Graph">
  <eClassifiers xsi:type="ecore:EClass" name="Graph">
    <eStructuralFeatures xsi:type="ecore:EReference" name="nodes" upperBound="-1"
        eType="#//Node" containment="true"/>
  </eClassifiers>
  <eClassifiers xsi:type="ecore:EClass" name="Node">
    <eStructuralFeatures xsi:type="ecore:EAttribute" name="name" eType="ecore:EDataType http://www.eclipse.org/emf/2002/Ecore#//EString"/>
    <eStructuralFeatures xsi:type="ecore:EReference" name="outgoing" upperBound="-1"
        eType="#//Edge" containment="true" eOpposite="#//Edge/source"/>
    <eStructuralFeatures xsi:type="ecore:EReference" name="incoming" upperBound="-1"
        eType="#//Edge" eOpposite="#//Edge/target"/>
  </eClassifiers>
  <eClassifiers xsi:type="ecore:EClass" name="Edge">
    <eStructuralFeatures xsi:type="ecore:EReference" name="source" eType="#//Node"
        eOpposite="#//Node/outgoing"/>
    <eStructuralFeatures xsi:type="ecore:EReference" name="target" eType="#//Node"
        eOpposite="#//Node/incoming"/>
  </eClassifiers>
</ecore:EPackage>
EOS
  end
  
  def code
"""rule Tree2Node 
  transform t : Tree!Tree
  to n : Graph!Node {
  
  n.name = t.label;
  
  // If t is not the top tree
  // create an edge connecting n
  // with the Node created from t's parent
  if (t.parent.isDefined()) {
    var e : new Graph!Edge;
    e.source ::= t.parent;
    e.target = n;
  }  
}"""
  end
end
