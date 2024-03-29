/*
 * generated by Xtext 2.32.0
 */
package com.itemis.mbse4me.dsls.ui.outline;

import java.util.List;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.jface.viewers.StyledString;
import org.eclipse.swt.graphics.Image;
import org.eclipse.xtext.nodemodel.INode;
import org.eclipse.xtext.nodemodel.util.NodeModelUtils;
import org.eclipse.xtext.ui.editor.outline.IOutlineNode;
import org.eclipse.xtext.ui.editor.outline.impl.DefaultOutlineTreeProvider;
import org.eclipse.xtext.ui.editor.outline.impl.EObjectNode;

import com.itemis.mbse4me.dsls.erModel.Assembly;
import com.itemis.mbse4me.dsls.erModel.AssemblyUsage;
import com.itemis.mbse4me.dsls.erModel.Component;
import com.itemis.mbse4me.dsls.erModel.ComponentUsage;
import com.itemis.mbse4me.dsls.erModel.ErModelPackage;
import com.itemis.mbse4me.dsls.erModel.Product;
import com.itemis.mbse4me.dsls.ui.utils.ErModelUiUtils;

/**
 * Customization of the default outline structure.
 *
 * See https://www.eclipse.org/Xtext/documentation/310_eclipse_support.html#outline
 */
public class ErModelOutlineTreeProvider extends DefaultOutlineTreeProvider {

	protected boolean _isLeaf(Product product) {
		return product.getAssemblyUsages().isEmpty();
	}

	protected boolean _isLeaf(Assembly assembly) {
		return assembly.getComponentUsages().isEmpty();
	}

	protected void _createChildren(IOutlineNode parent, Product product) {
		int i=0;
		for (AssemblyUsage assemblyUsage : product.getAssemblyUsages()) {
			Assembly assembly = assemblyUsage.getAssembly();
			String text = assemblyUsage.getCount() + " of " + assembly.getId() + " - " + assembly.getName();
			StyledString styledString = ErModelUiUtils.style(text);
			Image image = imageDispatcher.invoke(assembly);
			EObjectNode assemblyNode = createCustomEObjectNode(parent, product, i, image, styledString, false);
			_createChildren(assemblyNode, assembly);
			i++;
		}
	}

	protected void _createChildren(IOutlineNode parent, Assembly assembly) {
		int i=0;
		for (ComponentUsage componentUsage : assembly.getComponentUsages()) {
			Component component = componentUsage.getComponent();
			String text = componentUsage.getCount() + " of " + component.getId() + " - " + component.getName();
			StyledString styledString = ErModelUiUtils.style(text);
			Image image = imageDispatcher.invoke(component);
			createCustomEObjectNode(parent, assembly, i, image, styledString, true);
			i++;
		}
	}

	@Override
	protected EObjectNode createEObjectNode(IOutlineNode parentNode, EObject modelElement, Image image, Object text, boolean isLeaf) {
		if (modelElement instanceof Component) {
			Component component = (Component) modelElement;
			EObjectNode eObjectNode = new EObjectNode(modelElement, parentNode, image, text, isLeaf);
			INode parserNode = getComponentNameNode(component);
			if (parserNode != null) {
				eObjectNode.setTextRegion(parserNode.getTextRegion());
			}
			if (isLocalElement(parentNode, modelElement)) {
				eObjectNode.setShortTextRegion(parserNode.getTextRegion());
			}
			return eObjectNode;
		}

		if (modelElement instanceof Assembly) {
			Assembly assembly = (Assembly) modelElement;
			EObjectNode eObjectNode = new EObjectNode(modelElement, parentNode, image, text, isLeaf);
			INode parserNode = getAssemblyNameNode(assembly);
			if (parserNode != null) {
				eObjectNode.setTextRegion(parserNode.getTextRegion());
			}
			if (isLocalElement(parentNode, modelElement)) {
				eObjectNode.setShortTextRegion(parserNode.getTextRegion());
			}
			return eObjectNode;
		}

		return super.createEObjectNode(parentNode, modelElement, image, text, isLeaf);
	}

	protected EObjectNode createCustomEObjectNode(IOutlineNode parentNode, EObject parentEObject, int index, Image image, Object text, boolean isLeaf) {
		EObjectNode eObjectNode = new EObjectNode(parentEObject, parentNode, image, text, isLeaf);
		INode parserNode = null;
		if (parentEObject instanceof Product) {
			Product product = (Product) parentEObject;
			parserNode = getAssemblyInProductNode(product, index);
		}
		if (parentEObject instanceof Assembly) {
			Assembly assembly = (Assembly) parentEObject;
			parserNode = getComponentInAssemblyNode(assembly, index);
		}
		if (parserNode != null && isLocalElement(eObjectNode, parentEObject)) {
			eObjectNode.setTextRegion(parserNode.getTextRegion());
			eObjectNode.setShortTextRegion(parserNode.getTextRegion());
		}
		return eObjectNode;
	}

	private INode getComponentNameNode(Component component) {
		List<INode> componentNameNodes = NodeModelUtils.findNodesForFeature(component, ErModelPackage.Literals.COMPONENT__NAME);
		if (componentNameNodes.size() != 1) {
			System.err.println("Exact 1 node is expected for the component name: "	+ component.getName() + ", but got " + componentNameNodes.size());
			return null;
		}
		return componentNameNodes.get(0);
	}

	private INode getAssemblyNameNode(Assembly assembly) {
		List<INode> assemblyNameNodes = NodeModelUtils.findNodesForFeature(assembly, ErModelPackage.Literals.ASSEMBLY__NAME);
		if (assemblyNameNodes.size() != 1) {
			System.err.println("Exact 1 node is expected for the assembly name: "	+ assembly.getName() + ", but got " + assemblyNameNodes.size());
			return null;
		}
		return assemblyNameNodes.get(0);
	}

	private INode getComponentInAssemblyNode(Assembly assembly, int index) {
		List<INode> componentNodes = NodeModelUtils.findNodesForFeature(assembly, ErModelPackage.Literals.ASSEMBLY__COMPONENT_USAGES);
		return componentNodes.get(index);
	}

	private INode getAssemblyInProductNode(Product product, int index) {
		List<INode> assemblyNodes = NodeModelUtils.findNodesForFeature(product, ErModelPackage.Literals.PRODUCT__ASSEMBLY_USAGES);
		return assemblyNodes.get(index);
	}

}
