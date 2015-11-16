import Cocoa
import MetalKit

let ConstantBufferSize = 1024*1024*10

class GameViewController: NSViewController, MTKViewDelegate {
    
    var device: MTLDevice! = nil
    var commandQueue: MTLCommandQueue! = nil
    var pipelineState: MTLRenderPipelineState! = nil

    var vertexBuffer: MTLBuffer! = nil
    var vertexColorBuffer: MTLBuffer! = nil
    
    let inflightSemaphore = dispatch_semaphore_create(1)
    
    var fw_scene: FireworkScene! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        device = MTLCreateSystemDefaultDevice()
        // Fallback to a blank NSView, an application could also fallback to
        // OpenGL here.
        guard device != nil else { 
            print("Metal is not supported on this device")
            self.view = NSView(frame: self.view.frame)
            return
        }

        // setup view properties
        let view = self.view as! MTKView
        view.delegate = self
        view.device = device
        view.sampleCount = 4
        
        loadAssets()

        fw_scene = FireworkScene()
        let size = self.view.frame
        fw_scene.set_screen_size(width: Float(size.width), 
                height: Float(size.height))
    }
    
    func loadAssets() {
        
        // load any resources required for rendering
        let view = self.view as! MTKView
        commandQueue = device.newCommandQueue()
        commandQueue.label = "main command queue"
        
        let defaultLibrary = device.newDefaultLibrary()!
        let fragmentProgram = defaultLibrary.newFunctionWithName("passThroughFragment")!
        let vertexProgram = defaultLibrary.newFunctionWithName("passThroughVertex")!
        
        let psd = MTLRenderPipelineDescriptor()
        psd.vertexFunction = vertexProgram
        psd.fragmentFunction = fragmentProgram
        psd.colorAttachments[0].pixelFormat = view.colorPixelFormat
        psd.sampleCount = view.sampleCount

        // Enable blending
        psd.colorAttachments[0].blendingEnabled = true
        psd.colorAttachments[0].rgbBlendOperation = .Add
        psd.colorAttachments[0].alphaBlendOperation = .Add
        psd.colorAttachments[0].sourceRGBBlendFactor = .SourceAlpha
        psd.colorAttachments[0].sourceAlphaBlendFactor = .SourceAlpha
        psd.colorAttachments[0].destinationRGBBlendFactor = .OneMinusSourceAlpha
        psd.colorAttachments[0].destinationAlphaBlendFactor = .OneMinusSourceAlpha

        do {
            try pipelineState = device.newRenderPipelineStateWithDescriptor(psd)
        } catch let error {
            print("Failed to create pipeline state, error \(error)")
        }
        
        vertexBuffer = device.newBufferWithLength(ConstantBufferSize, options: [])
        vertexBuffer.label = "vertices"

        vertexColorBuffer = device.newBufferWithLength(ConstantBufferSize, options: [])
        vertexColorBuffer.label = "colors"
    }
    
    func drawInMTKView(view: MTKView) {
        dispatch_semaphore_wait(inflightSemaphore, DISPATCH_TIME_FOREVER)
        
        // get buffers ready for writing
        var bv = BufferWrapper(vertexBuffer)
        var bc = BufferWrapper(vertexColorBuffer)
        clearBackground(&bv, &bc)
        precondition(bv.pos == bc.pos)
        fw_scene.update(bv: &bv, bc: &bc)
        precondition(bv.pos == bc.pos)

        let vertexCount = bv.pos / 4
        
        let commandBuffer = commandQueue.commandBuffer()
        commandBuffer.label = "Frame command buffer"
        
        // use completion handler to signal the semaphore when this frame is
        // completed allowing the encoding of the next frame to proceed
        // use capture list to avoid any retain cycles if the command buffer
        // gets retained anywhere besides this stack frame
        commandBuffer.addCompletedHandler{ [weak self] commandBuffer in
            if let strongSelf = self {
                dispatch_semaphore_signal(strongSelf.inflightSemaphore)
            }
            return
        }
        
        if let renderPassDescriptor = view.currentRenderPassDescriptor, currentDrawable = view.currentDrawable
        {
            let renderEncoder = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDescriptor)
            renderEncoder.label = "render encoder"
            
            renderEncoder.pushDebugGroup("draw morphing triangle")
            renderEncoder.setRenderPipelineState(pipelineState)
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, atIndex: 0)
            renderEncoder.setVertexBuffer(vertexColorBuffer, offset: 0, atIndex: 1)
            renderEncoder.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: vertexCount)
            renderEncoder.popDebugGroup()
            renderEncoder.endEncoding()
                
            commandBuffer.presentDrawable(currentDrawable)
        }
        
        commandBuffer.commit()
    }
    
    
    func mtkView(view: MTKView, drawableSizeWillChange size: CGSize) {
        fw_scene.set_screen_size(width: Float(size.width), 
                height: Float(size.height))
    }


    // Draw two triangles and clear the background.
    func clearBackground(inout v: BufferWrapper, inout _ c: BufferWrapper) {
        let vertexBackground:[Float] = [
         -1.0, -1.0, 0.0, 1.0,
         -1.0,  1.0, 0.0, 1.0,
          1.0, -1.0, 0.0, 1.0,
         
          1.0, -1.0, 0.0, 1.0,
          1.0,  1.0, 0.0, 1.0,
         -1.0,  1.0, 0.0, 1.0,
        ]

        let bgcolor = Color4(r: 0.0, g: 0.0, b: 0.0, a: 1.0)
        let vertexBackgroundColor:[Color4] = [
            bgcolor,
            bgcolor,
            bgcolor,

            bgcolor,
            bgcolor,
            bgcolor,
        ]

        for f in vertexBackground {
            v.append(f)
        }
        for f in vertexBackgroundColor {
            c.append(f)
        }
    }
}
