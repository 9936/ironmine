package com.handchina.ironmine;


import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import javax.swing.JPanel;

public class ImagePanel extends JPanel
{

	private static final long serialVersionUID = 0x4e283f9d481dd751L;
	private BufferedImage image;

	public ImagePanel()
	{
		super(true);
	}

	public BufferedImage getImage()
	{
		return image;
	}

	public void setImage(BufferedImage image)
	{
		this.image = image;
		if (image != null)
			setPreferredSize(new Dimension(image.getWidth(), image.getHeight()));
		updateUI();
	}

	protected void paintComponent(Graphics g)
	{
		super.paintComponent(g);
		if (image != null)
			g.drawImage(image, 0, 0, this);
	}
}
