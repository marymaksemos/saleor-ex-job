import NextImage, { type ImageProps } from "next/image";

export const ProductImageWrapper = (props: ImageProps) => {
	return (
		<div className="group relative aspect-square overflow-hidden">
			<NextImage {...props} className="h-full w-full object-contain object-center" />
			<div className="absolute inset-0 hidden items-center justify-center bg-white/20 backdrop-blur-sm group-hover:flex">
				<button className="bg-black px-12 py-2.5 text-white">Quick View</button>
			</div>
		</div>
	);
};
